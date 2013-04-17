require "fake_zip/version"

require 'yaml'
require 'forwardable'
require 'zip/zipfilesystem'


module FakeZip

  ####################

  module Helpers
    extend self

    def traverse array_or_hash, path=[], &block
      given = array_or_hash
      case given
      when Hash
        given.each_pair do |k,v|
          block.call path+[k], :dir # entering directory
          traverse v,path+[k],&block
        end
      when Array then given.each { |x| traverse x,path,&block }
      else
        block.call path+[given], :file
      end
    end

    def collect_all(given)
      found = []
      traverse given do |x,y| found << [x,y] end
      found
    end
    def collect_only(given, kind)
      collect_all(given).map { |(name,type)| name if type == kind }.compact
    end    
    def files(given)
      collect_only(given, :file).map { |x| x.join ?/ }
    end
    def dirs(given)
      collect_only(given, :dir).map { |x| x.join ?/ }
    end     
  end 

  ####################

  class FakeZip < Struct.new :file_structure
    def save file
      Zip::ZipFile.open file, Zip::ZipFile::CREATE do |z|
        dirs(struct).each do |dir|
          z.dir.mkdir(dir) unless z.file.exist? dir
        end
        files(struct).each do |file|
          z.file.open(file, "w") { |f| f.write file }
        end      
      end
    end

    def struct given=file_structure
      given.is_a?(String) ? YAML.load(given) : given
    end

    private

    extend Forwardable
    def_delegators Helpers, :files, :dirs   
  end

  def new file, structure
    FakeZip.new(structure).save file
  end

  module_function :new  
end


__END__
# Other tests...

found = []
FakeZip::Helpers.traverse( {a: [{a: 1, b: 2}, 3]}, &proc{ |x| found << x } )
found.map { |x| x.join ?/ } == ["a", "a/a", "a/a/1", "a/b", "a/b/2", "a/3"] or raise

FakeZip::Helpers.files({a: [{a: 1, b: 2}, 3]}) == %w[ a/a/1  a/b/2  a/3 ] or raise


require 'yaml'

raise unless FakeZip('empty_dir: []').contents == {'empty_dir' => []}
raise unless FakeZip('dir: [file1, file2]').contents == {'dir' => ['file1','file2']}

tree = 'root_dir: [file1, file2, nested_dir: []]'
raise unless FakeZip(tree).contents == {'root_dir' => ['file1','file2',{'nested_dir' => [] }]}

file_name = 'temp-test-fake.zip'
tree = 'root_dir: [file1, file2, nested_dir: [nested_file.any], empty_dir: []]'
FakeZip(tree).save file_name

Zip::ZipFile.open file_name do |z|
  z.file.exist? 'root_dir/file1' or raise
  z.file.exist? 'root_dir/file2' or raise
  z.file.exist? 'root_dir/nested_dir/nested_file.any' or raise
  z.file.exist? 'root_dir/empty_dir' or raise # no empty dirs
end 
File.delete file_name
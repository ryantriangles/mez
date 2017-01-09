# Configuration and the SQLite database are stored in ~/.mez/ on macOS
# and Linux, and in %localappdata%/mez on Windows.
require 'sqlite3'
require 'date'
require 'os'
require 'json'
require 'fileutils'
require 'win32ole' if OS.windows?

module Mez
  APP_DIR = if OS.windows?
              File.join(File.expand_path('~'), 'appdata', 'local', 'mez')
            else
              File.join(File.expand_path('~'), '.mez')
            end
  CONFIG = File.join(APP_DIR, 'folders.json')
  DB = if File.exist?(File.join(APP_DIR, 'folders.db'))
         SQLite3::Database.new(File.join(APP_DIR, 'folders.db'))
       else
         FileUtils.mkdir_p(APP_DIR) unless File.exist?(APP_DIR)
         db = SQLite3::Database.new(File.join(APP_DIR, 'folders.db'))
         db.execute('CREATE TABLE folders (name string, date string, size int,
                     PRIMARY KEY ("name", "date"))')
         db
       end

  # Calculates the size of a folder and its contents as an integer.
  # On Windows, uses the Win32 API, which caches folder information and makes
  # repeated calls to this function very fast. On other systems, sums individual
  # file sizes.
  #
  # @param folder [String] a path to a folder, eg '~/books' or 'c:\books'
  # @return [Integer] the folder's size in bytes
  def self.folder_size(folder)
    if OS.windows?
      # Much faster for repeated calls than calculating sizes in Ruby.
      WIN32OLE.new('Scripting.FileSystemObject').getFolder(folder).size.to_i
    else
      size = 0
      Dir.glob(File.join(folder, '**', '*')) { |file| size += File.size(file) }
      size
    end
  end

  # Uses commas as separators to make large numbers human-readable.
  #
  # @param num [Integer] any integer, eg -48151
  # @return [String] a human readable number, eg "-48,151"
  def self.humanise(num)
    (prefix(num) == '-' ? '-' : '') + num
                                      .abs
                                      .to_s
                                      .split('')
                                      .reverse
                                      .each_slice(3)
                                      .map(&:join)
                                      .join(',')
                                      .reverse
  end

  # Provide a "+" or "-" prefix based on whether `n` is positive or negative.
  #
  # @param n [Number]
  # @return [String] "+" or "-"
  def self.prefix(n)
    n >= 0 ? '+' : '-'
  end

  # Format a number for the 'change' column, meaning a + or - prefix and a
  # number in bytes converted to a comma-separated number in IEC megabytes.
  #
  # @param n [Integer] size differential in bytes
  # @return [String] "+48,151"
  def self.difference_report(n)
    n.zero? ? '' : prefix(n) + humanise(n.abs / 1_000_000)
  end

  def self.yesterday_size(name)
    DB.get_first_value('SELECT size FROM folders
                        WHERE name = ? AND date <> ?
                        ORDER BY date DESC
                        LIMIT 1', name, Date.today.to_s)
  end

  def self.report(name, size, difference)
    puts name.ljust(54) +
         humanise(size / 1_000_000).rjust(10) +
         difference_report(difference).rjust(16)
  end

  def self.intro_line
    puts "\nFOLDERSET".ljust(56) + 'SIZE (MB)' + 'CHANGE (MB)'.rjust(16)
    puts('-' * 80)
  end

  # Take an array of folder names, and return their total size in bytes.
  #
  # @param [Array<String>] array of folder names
  # @return [Integer] total size of all folders and their contents
  def self.setsize(folderset)
    folderset.reduce(0) { |acc, elem| acc + Mez.folder_size(elem) }
  end

  def self.closing_line(total_size, total_difference)
    puts('-' * 80)
    puts 'TOTAL SIZE: ' +
         humanise(total_size / 1_000_000) +
         ('TOTAL CHANGE: ' + humanise(total_difference / 1_000_000)).rjust(59)
  end

  def self.update(name, size)
    DB.execute('INSERT OR REPLACE INTO folders
                (name, size, date)
                VALUES (?,?,?)', name, size, Date.today.to_s)
  end
end

require 'pg'
require 'csv'
require 'active_record'
require 'rubygems'

class Parser < ActiveRecord::Base
  attr_reader :file, :records

  def initialize(file)
    @records = []
    @file = file
    parse
    # seed_db
  end

  def parse
    return @records unless @records.empty?
    i = 0
    CSV.foreach(@file, :unconverted_fields => true, :converters => :all, :headers => true, :header_converters => :symbol) do |row|
      @records << Line.new(row.to_hash)
      i += 1
      puts i
    end
    @records
  end

  # def initialize_db
  #   $db.execute(<<-SQL
  #     CREATE TABLE records (
  #       id INTEGER PRIMARY KEY AUTOINCREMENT,
  #       report_type INTEGER NOT NULL,
  #       patient_name VARCHAR(64) NOT NULL,
  #       service_from VARCHAR(64) NOT NULL,
  #       service_thru VARCHAR(64) NOT NULL,
  #       paid_date VARCHAR(64) NOT NULL,
  #       hic_num VARCHAR(64) NOT NULL,
  #       gross_reimb VARCHAR(64) NOT NULL,
  #       cash_deduct VARCHAR(64) NOT NULL,
  #       blood_deduct VARCHAR(64) NOT NULL,
  #       coins VARCHAR(64) NOT NULL,
  #       net_reimb VARCHAR(64) NOT NULL,
  #       );
  #   SQL
  #   )
  # end

  def seed_db
    @records.each do |row|
      $db.execute(
        "INSERT INTO records
        (report_type, patient_name, service_from, service_thru, paid_date, hic_num, gross_reimb, cash_deduct, blood_deduct, coins, net_reimb)
        VALUES
        ('#{record.report_type}', '#{record.patient_name}', '#{record.service_from}', '#{record.service_thru}', '#{record.paid_date}', '#{record.hic_num}', '#{record.gross_reimb}', '#{record.cash}', '#{record.blood_deduct}', '#{record.coins}', '#{record.net_reimb}');")
    end
  end
end

parser = Parser.new('for_don2.csv')




# encoding: utf-8
# Creation of Price and Product Service test data for Tesco-Dunnhumby Tibco testing.
# All data follows suggested format but is aimed to be hyperthetical, non-live data

require 'json'

# To reference output directories and filenames 
module Outputs
	Output_Directory = 'D:\Code\TibcoTestDataGenerator\\'
	Output_Filename = 'price_service_fake_response.json'
end

# A Price Record to return keys and values for each parameter returned bythe Price Service and Setup all static data
# Records are built from random selection from these data arrays. One array for each of the parameters returned from the Price Service. 
class PriceRecord
  @count = 0
  class << self
    attr_accessor :count
  end

	attr_accessor :itemNumber

  def initialize
		@ary_shelftalkerimage = 
			["http://ui.tescoassets.com/Groceries/UIAssets/I/Sites/Retail/Superstore/Online/Product/pos/specialpurchase.png",
		 	 "http://ui.tescoassets.com/Groceries/UIAssets/I/Sites/Retail/Superstore/Online/Product/pos/offer.png"]
  	@ary_offerid = 
			["RELPA0001", "RELPA0002", "RELPA0003", "RELPA0004", "RELPA0005", "RELPA0006", "RELPA0007", "RELPA0008", "RELPA0009", "RELPA0010"]
    @itemNumber
		@ary_zoneid = ("1".."12").zip.flatten
		@ary_cfdescription1 = 
			["Save 49p Was £1.49 Now £1.00",
		 	 "Half price",
		 	 "80p off"]
		@ary_cfdescription2 = 
			["null",
		 	 "ONE BODY|MASSAGE TWISTER   Crossed out prices charged at most Tesco stores in GB",]
		@ary_offername = 
			["T. BRWN SAUCE SQUEEZY 485G 1>0.89 SV 0.11",
		 	 "GLADIOLI BUNCH WOW 2.50",
		 	 "ONE BODY MASSAGE TWISTER W5 N3.75 S1.25"]
    self.class.count += 1
	end
	def get_rndm_shelfTalkerImage
		@ary_shelftalkerimage.sample
	end
  def get_rndm_offerId
  	@ary_offerid.sample
  end
  def get_itemNumber
    self.itemNumber = "%09d" % PriceRecord.count
    @itemNumber
  end
  def get_rndm_zoneId
  	@ary_zoneid.sample
  end
  def get_rndm_CFDescription1
  	@ary_cfdescription1.sample
  end
  def get_rndm_CFDescription2
  	@ary_cfdescription2.sample
  end
  def get_rndm_offerName
  	@ary_offername.sample
  end
  def get_rndm_startDate
  	Time.at(Time.now - (rand * 604_800).to_i).strftime("%d/%m/%Y %H:%M:%S")
  end
  def get_rndm_endDate
  	Time.at(Time.now + (rand * 604_800).to_i).strftime("%d/%m/%Y")
  end
  def create_rndm_record # build a randomised record using a call for each of the Price Service parameters 
  	price_record = {
  	  "shelfTalkerImage" => get_rndm_shelfTalkerImage,
  	  "offerId" => get_rndm_offerId,
  	  "itemNumber" => get_itemNumber,
  	  "zoneId" => get_rndm_zoneId,
  	  "CFDescription1" => get_rndm_CFDescription1,
  	  "CFDescription2" => get_rndm_CFDescription2,
  	  "offerName" => get_rndm_offerName,
  	  "startDate" => get_rndm_startDate,
  	  "endDate" => get_rndm_endDate
    }
  end
end

# Price Respose returns a correctly formatted JSON response as per the Price Service
class PriceResponse
	include Outputs

	def initialize
		@ary = []
		@json_resp
	end
	def create_new_response(n) # n, number of records to be returned
		@ary = []
		n.times do |rec|
  	  rec = PriceRecord.new.create_rndm_record
  	  @ary << rec
  	end
  	@json_resp = JSON.pretty_generate(@ary) # reformat JSON response to include line breaks, indentation and spacing
  end
	def write_response_to_file
		File.open("#{Outputs::Output_Directory + Outputs::Output_Filename}", 'w') { |file| file.write(@json_resp) }
		puts "Price Service response written to file #{Outputs::Output_Directory + Outputs::Output_Filename}"
	end
end


# prompt user in line for integer value for number of records to be returned
puts "How many fake records do you want to create?"
n = gets.chomp.to_i
resp = PriceResponse.new
resp.create_new_response(n)
resp.write_response_to_file

class CrawlerController < ApplicationController

	def new
	end

	def validate
		file = File.read(params[:file].path)
		@data_hash = JSON.parse(file)
	end
end

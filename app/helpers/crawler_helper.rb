module CrawlerHelper
	# gives each record with record, errors, error_count, warnings, warning_count
	def total_stats(records, host_name)
		result = {stats: []}
		records.each do |r|
			rec = Crawler.new(r, host_name)
      rec.valid?
      errors =  rec.errors.full_messages
      rec.has_warnings?
      warnings = rec.warnings.full_messages
      result[:stats] << { record: rec, errors: errors, errors_count: errors.count,
      										warnings: warnings, warnings_count: warnings.count }
		end
		result[:stats]
	end
end

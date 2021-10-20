class EntryRepository < Hanami::Repository
  def list_by_desc_date(limit:, page: 1, year: nil, month: nil)
    if (year.nil? ^ month.nil?)
      raise ArgumentError, "year and month must be both specified or both unspecified"
    end

    offset = limit * (page - 1)

    if !year.nil? && !month.nil?
      begin_of_month = Date.new(year, month, 1)
      begin_of_next_month = (begin_of_month >> 1)
      entries
        .order { date.desc }
        .limit(limit)
        .offset(offset)
        .where { (date >= begin_of_month) & (date < begin_of_next_month) }
        .to_a
    else
      entries
        .order { date.desc }
        .limit(limit)
        .offset(offset)
        .to_a
    end
  end
end

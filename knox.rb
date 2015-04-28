require 'csv'

class Knox
  def initialize()
    @datas = []
  end

  def read(file_path:, sequence: [], separator: ',', dateformat: "mm/dd/yy", line_break: "\r")
    IO.readlines(file_path, line_break).each do |line|
      next if line.length < 8
      arr = split_line(line, separator, sequence.count)
      data = Base.new
      sequence.each_with_index do |field, index|
        value = clean_string(arr[index])
        if field.downcase == "date"
          value = format_date(value, dateformat)
        end
        data.send("#{field.downcase}=".to_sym, value)
        data.exchangename = file_path.match(/\/([^\/]*)\.txt/)[1]
      end
      @datas << data
    end
  end

  # output to csv
  def export_csv
    CSV.open('results.csv', 'wb') do |csv|
      @datas.sort.each do |data|
        csv << data.to_array
      end
    end
  end


  def results
    @datas
  end

  private
  def split_line(line="", separator=",", num=5)
    arr = line.split(separator)
    if arr.count > num
      array = []
      tmp_elements = []
      arr.each do |element|
        if element.include? "\"" or element.include? "\'"
          if element.end_with?("\"") or element.end_with?("\'")
            tmp_elements.push(element)
            array.push(tmp_elements.join(" "))
          else
            tmp_elements.push(element)
          end
        else
          array.push(element)
        end
      end
      return array
    else
      return arr
    end
  end

  def clean_string(string="")
    if string
      string.strip.gsub(/[\"']/, "")
    else
      ""
    end
  end

  def format_date(date, dateformat)
    case dateformat.length
    when 8
      format = dateformat.gsub(/yy/, "%y").gsub(/mm/, "%m").gsub(/dd/, "%d")
    when 10
      format = dateformat.gsub(/yyyy/, "%Y").gsub(/mm/, "%m").gsub(/dd/, "%d")
    else
      return ""
    end
    Date.strptime(date, format)
  end
end

class Base
  include Comparable
  attr_accessor :adcampaignname, :exchangename, :date, :clicks, :impressions, :totalspend

  def data
    {ad_campaign_name: self.adcampaignname,
     exchange_name: self.exchangename, 
     date: self.date,
     clicks: self.clicks,
     impressions: self.impressions,
     spend: self.totalspend}
  end
  
  def to_array
    [self.exchangename, format_date(self.date), self.adcampaignname, self.clicks, self.impressions, self.totalspend]
  end

  def format_date(date, format="%m/%d/%Y")
    date.strftime(format)
  end

  def <=>(another)
    if click_impression?(another) == 0 
      if date == another.date
        if exchangename == another.exchangename
          another.adcampaignname <=> adcampaignname 
        else
          exchangename <=> another.exchangename
        end
      else
        date <=> another.date
      end
    else
      click_impression?(another)
    end
  end

  def click_impression?(another)
    if clicks > impressions * 0.1 and another.clicks <= another.impressions * 0.1
      1
    elsif another.clicks > another.impressions * 0.1 and clicks <= impressions * 0.1
      -1
    else
      0
    end
  end
end

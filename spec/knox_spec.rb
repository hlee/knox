require 'spec_helper'

describe Knox do
  it "read the BannerMart file and correct sort" do
    knox = Knox.new
    knox.read(file_path: './files/bannermart.txt', sequence: ["date", "AdCampaignName", "Clicks", "Impressions", "TotalSpend"], separator: ' | ', dateformat: 'mm/dd/yy', line_break: "\r")
    knox.read(file_path: './files/ads-r-us.txt', sequence: ["AdCampaignName", "Impressions", "Clicks", "TotalSpend", "date"], separator: ', ', dateformat: 'dd/mm/yyyy', line_break: "\n")
    knox.read(file_path: './files/TrippleClick.txt', sequence: ["Impressions", "Clicks", "TotalSpend", "AdCampaignName", "date"], separator: ' ', dateformat: 'yyyymmdd', line_break: "\r")
    cell1 = knox.results[1]
    cell2 = knox.results[2]
    cell3 = knox.results[3]
    cell4 = knox.results[4]
    cell1.clicks, cell1.impressions, cell1.date = 12, 7, Date.parse('2015/07/30')
    cell2.clicks, cell2.impressions, cell2.date = 10, 7, Date.parse('2015/04/25')
    cell3.clicks, cell3.impressions, cell3.date, cell3.adcampaignname = 10, 700, Date.parse('2015/03/25'), 'AAA'
    cell4.clicks, cell4.impressions, cell4.date, cell4.adcampaignname = 10, 700, Date.parse('2015/03/25'), 'Zoo'
    expect([cell1, cell2, cell3, cell4].sort).to eq [cell2, cell1, cell4, cell3]
  end
end

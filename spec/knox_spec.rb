require 'spec_helper'

describe Knox do
  it "read the BannerMart file" do
    knox = Knox.new
    knox.read(file_path: './files/bannermart.txt', sequence: ["date", "AdCampaignName", "Clicks", "Impressions", "TotalSpend"], separator: ' | ', dateformat: 'mm/dd/yy', line_break: "\r")
    knox.read(file_path: './files/ads-r-us.txt', sequence: ["AdCampaignName", "Impressions", "Clicks", "TotalSpend", "date"], separator: ', ', dateformat: 'dd/mm/yyyy', line_break: "\n")
    knox.read(file_path: './files/TrippleClick.txt', sequence: ["Impressions", "Clicks", "TotalSpend", "AdCampaignName", "date"], separator: ' ', dateformat: 'yyyymmdd', line_break: "\r")
    knox.export_csv
  end
end

SCHEDULER.every '10s' do
  begin
    http = Net::HTTP.new('192.168.50.104', 9090)
    response = http.request(Net::HTTP::Get.new("/api/v1/query?query=node_boot_time_seconds"))
    next unless '200'.eql? response.code
    prom_data1  = JSON.parse(response.body)
    response2 = http.request(Net::HTTP::Get.new("/api/v1/query?query=node_time_seconds"))
    next unless '200'.eql? response.code
    prom_data2 = JSON.parse(response2.body)

    last_valuation = (prom_data2["data"]["result"][0]["value"][1].to_f - prom_data1["data"]["result"][0]["value"][1].to_f) / 60
    last_valuation = last_valuation.round

    send_event('uptime', { current: last_valuation, last: last_valuation })
    send_event('synergy',   { value: rand(100) })
  rescue StandardError => e
    puts "Error: #{e.message}"
    send_event('uptime', { current: 'off', last: '0' })
    send_event('synergy',   { value: 'off' })
  end
end
require 'cuba'

$requests = 10

Cuba.define do
  on root do
    res.write "<form action='/health-check'><input type='submit' name='anomaly' value='Add Anomaly'></form>"
  end

  on 'health-check' do
    if env["QUERY_STRING"].empty? && $requests == 10
      $requests = 10
      if rand > 0.8
        res.status = 500
      else
        res.status = 200
      end
    else
      $requests -= 1
      $requests = 10 if $requests == 0
      if rand > 0.7
        sleep(0.9)
        res.status = 200
      else
        res.status = 500
      end
    end
  end
end

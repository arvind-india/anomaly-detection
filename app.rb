require 'cuba'

Cuba.define do
  on root do
    res.write 'hello'
  end

  on 'health-check' do
    if rand > 0.8
      res.status = 500
    else
      res.status = 200
    end
  end
end

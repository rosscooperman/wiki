require 'machinist/active_record'

Page.blueprint do
  title   { "Title_#{sn}" }
  content { "Content_#{sn}" }
end

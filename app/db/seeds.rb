# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Question.destroy_all
Type.destroy_all
Topic.destroy_all

case ActiveRecord::Base.connection.adapter_name
when "PostgreSQL"
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE topics_id_seq RESTART WITH 1;")
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE types_id_seq RESTART WITH 1;")
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE questions_id_seq RESTART WITH 1;")
when "SQLite"
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='topics';")
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='types';")
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='questions';")
end

topics = Topic.create([
  { topic_id: 1, topic_name: "Basic Statistical Measurements" },
  { topic_id: 2, topic_name: "Propagation of Error" },
  { topic_id: 3, topic_name: "Finite Differences" },
  { topic_id: 4, topic_name: "Basic Experimental Statistics & Probabilities" },
  { topic_id: 5, topic_name: "Confidence Intervals" },
  { topic_id: 6, topic_name: "UAE (Universal Accounting Equation)" }
])

types = Type.create([
  { type_id: 1, type_name: "Definition" },
  { type_id: 2, type_name: "Free response" }
])

questions = Question.create([
  {
    topic_id: topics[0].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "Given the data: [\\(a\\), \\(b\\), \\(c\\), \\(d\\), \\(e\\), \\(f\\), \\(g\\), \\(h\\), \\(i\\), \\(j\\), \\(k\\), \\(l\\), \\(m\\), \\(n\\), \\(o\\), \\(p\\), \\(q\\), \\(r\\), \\(s\\), \\(t\\), \\(u\\), \\(v\\), \\(w\\), \\(x\\), \\(y\\)] Determine the mean. Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
    equation: '(a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q + r + s + t + u + v + w + x + y) / 25',
    variables: [ "a", "b", "c", "d", "e",
                 "f", "g", "h", "i", "j",
                 "k", "l", "m", "n", "o",
                 "p", "q", "r", "s", "t",
                 "u", "v", "w", "x", "y" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, take the sum of the values above and divide that sum by the number of values (25).'
  }
#   {
#   topic_id: 2,  # "Propagation of Error"
#   type_id: 2,   # "Free response"
#   img: nil,
#   template_text: "Given the mass [\\( m \\pm Δ m \\)], acceleration due to gravity [\\( g \\pm \\Delta g \\)], and height [\\( h \\pm \\Delta h \\)], the energy is given by [\\( E = m g h \\)]. Calculate the propagated error in Joules for the energy. Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
#   equation: "sqrt((g*h*dm)**2 + (m*h*dg)**2 + (m*g*dh)**2)",
#   variables: ["m", "dm", "g", "dg", "h", "dh"],
#   answer: nil,
#   correct_submissions: 0,
#   total_submissions: 0,
#   explanation: "To solve this problem, use the standard propagation-of-error formula for a product of three measured quantities. The partial-derivative approach leads to sqrt( (g*h*dm)^2 + (m*h*dg)^2 + (m*g*dh)^2 )."
# },
# {
#   topic_id: 2,  # "Propagation of Error"
#   type_id: 2,   # "Free response"
#   img: nil,
#   template_text: "Given the parameters [\\( a \\pm Δ a \\)] and [\\( b \\pm \\Delta b \\)], the temperature is given by [\\( T = a^b \\)]. Calculate the propagated error in T. Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
#   equation: "sqrt((b*a**(b-1)*da)**2 + (a**b*ln(a)*db)**2)",
#   variables: ["a", "da", "b", "db"],
#   answer: nil,
#   correct_submissions: 0,
#   total_submissions: 0,
#   explanation: "Use partial derivatives of T = a^b with respect to a and b, then combine them in quadrature. The derivatives are dT/da = b a^(b-1) and dT/db = a^b ln(a)."
# }
  # {
  #   topic_id: topics[0].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: "Given the data: [\\( a \\), \\( b \\), \\( c \\), \\( d \\), \\( e \\), \\( f \\), \\( g \\), \\( h \\), \\( i \\), \\( j \\), \\( k \\), \\( l \\), \\( m \\), \\( n \\), \\( o \\), \\( p \\), \\( q \\), \\( r \\), \\( s \\), \\( t \\), \\( u \\), \\( v \\), \\( w \\), \\( x \\), \\( y \\)] Determine the median. Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
  #   equation: '([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y].sort)[12]',
  #   variables: [ "a", "b", "c", "d", "e",
  #                "f", "g", "h", "i", "j",
  #                "k", "l", "m", "n", "o",
  #                "p", "q", "r", "s", "t",
  #                "u", "v", "w", "x", "y" ],
  #   answer: nil,
  #   correct_submissions: 0,
  #   total_submissions: 0,
  #   explanation: 'To find the median, sort all 25 values and select the 13th one (index 12).'
  # },
  # {
  #   topic_id: topics[0].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: "Given the data: [\\( a \\), \\( b \\), \\( c \\), \\( d \\), \\( e \\), \\( f \\), \\( g \\), \\( h \\), \\( i \\), \\( j \\), \\( k \\), \\( l \\), \\( m \\), \\( n \\), \\( o \\), \\( p \\), \\( q \\), \\( r \\), \\( s \\), \\( t \\), \\( u \\), \\( v \\), \\( w \\), \\( x \\), \\( y \\)] Determine the mode. Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
  #   equation: '([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y].group_by { |val| val }.max_by { |_k,v| v.size }[0])',
  #   variables: [ "a", "b", "c", "d", "e",
  #                "f", "g", "h", "i", "j",
  #                "k", "l", "m", "n", "o",
  #                "p", "q", "r", "s", "t",
  #                "u", "v", "w", "x", "y" ],
  #   answer: nil,
  #   correct_submissions: 0,
  #   total_submissions: 0,
  #   explanation: 'To find the mode, identify which value appears most frequently in the set.'
  # },
  # {
  #   topic_id: topics[0].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: "Given the data: [\\( a \\), \\( b \\), \\( c \\), \\( d \\), \\( e \\), \\( f \\), \\( g \\), \\( h \\), \\( i \\), \\( j \\), \\( k \\), \\( l \\), \\( m \\), \\( n \\), \\( o \\), \\( p \\), \\( q \\), \\( r \\), \\( s \\), \\( t \\), \\( u \\), \\( v \\), \\( w \\), \\( x \\), \\( y \\)] Determine the range. Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
  #   equation: '([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y].max - [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y].min)',
  #   variables: [ "a", "b", "c", "d", "e",
  #                "f", "g", "h", "i", "j",
  #                "k", "l", "m", "n", "o",
  #                "p", "q", "r", "s", "t",
  #                "u", "v", "w", "x", "y" ],
  #   answer: nil,
  #   correct_submissions: 0,
  #   total_submissions: 0,
  #   explanation: 'The range is the difference between the maximum and minimum values in the set.'
  # },
  # {
  #   topic_id: topics[0].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: "Given the data: [\\( a \\), \\( b \\), \\( c \\), \\( d \\), \\( e \\), \\( f \\), \\( g \\), \\( h \\), \\( i \\), \\( j \\), \\( k \\), \\( l \\), \\( m \\), \\( n \\), \\( o \\), \\( p \\), \\( q \\), \\( r \\), \\( s \\), \\( t \\), \\( u \\), \\( v \\), \\( w \\), \\( x \\), \\( y \\)] Determine the standard deviation. Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
  #   equation: 'Math.sqrt([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y].map{|val| (val - ((a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y)/25.0))**2 }.sum / 25.0)',
  #   variables: [ "a", "b", "c", "d", "e",
  #                "f", "g", "h", "i", "j",
  #                "k", "l", "m", "n", "o",
  #                "p", "q", "r", "s", "t",
  #                "u", "v", "w", "x", "y" ],
  #   answer: nil,
  #   correct_submissions: 0,
  #   total_submissions: 0,
  #   explanation: 'Standard deviation is the square root of the average of the squared differences from the mean.'
  # },
  # {
  #   topic_id: topics[0].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: "Given the data: [\\( a \\), \\( b \\), \\( c \\), \\( d \\), \\( e \\), \\( f \\), \\( g \\), \\( h \\), \\( i \\), \\( j \\), \\( k \\), \\( l \\), \\( m \\), \\( n \\), \\( o \\), \\( p \\), \\( q \\), \\( r \\), \\( s \\), \\( t \\), \\( u \\), \\( v \\), \\( w \\), \\( x \\), \\( y \\)] Determine the variance. Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
  #   equation: '([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y].map{|val| (val - ((a+b+c+d+e+f+g+h+i+j+k+l+m+n+o+p+q+r+s+t+u+v+w+x+y)/25.0))**2 }.sum / 25.0)',
  #   variables: [ "a", "b", "c", "d", "e",
  #                "f", "g", "h", "i", "j",
  #                "k", "l", "m", "n", "o",
  #                "p", "q", "r", "s", "t",
  #                "u", "v", "w", "x", "y" ],
  #   answer: nil,
  #   correct_submissions: 0,
  #   total_submissions: 0,
  #   explanation: 'Variance is the average of the squared differences from the mean.'
  # }
])
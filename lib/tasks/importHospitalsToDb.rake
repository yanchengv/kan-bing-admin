#encoding:utf-8


namespace :db do
    desc  'import hospital data'

    task hosp: :environment do
      
    hosp_data
  end
end

def hosp_data
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open '/home/git/hosp130903.xls'
sheets = book.worksheets
#p sheets
i = 0
sheet1 = book.worksheet  0
hosarr =[]

count = sheet1.rows.count
sheet1.each  do |row|
  

  p "rowo :#{row[0]}"



obj= {  city_name: row[0], rank: row[1], name: row[2] ,address:row[3], phone: row[4], key_departments: row[5], email: row[6],hospital_site: row[6], fax_number: row[7] }

hosarr << obj
if  i< count  && i%10 ==0
 p  hosarr
 Hospital.create(hosarr)
hosarr = []
p hosarr
p "-------------------->"
end



  i = i+1


 

end
   

end

namespace :db do
  desc  'import expert data'

  task ep: :environment do

# zhiwu  name gender  birthday  zhicheng   zhuanye   danwei   dianhua  zipcode
#
# name   gender nationality  birthday   political organization  professionalTitle  position  expertise  officePhone  mobile_phone ,email,#   name   gender nationality  birthday   political organization  professional_title  position  expertise  office_phone  mobile_phone email  academicianAt     outstandingAt   allowanceAt   is_centercontact  note1 note2  retireyear
# rails  g scaffold  name:string gender:string nationality:string



#政治面貌   行政支撑
  end

    exp_data
  end


  def exp_data
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open '/home/git/data/234.xls'
    sheets = book.worksheets
#p sheets
    i = 0
    sheet1 = book.worksheet  0
    hosarr =[]

    count = sheet1.rows.count
    sheet1.each  do |row|


    end



end
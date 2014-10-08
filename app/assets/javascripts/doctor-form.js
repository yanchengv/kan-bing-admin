/**
 * Created by git on 14-10-8.
 */
var credential_type_number_flag=true
function check_credential_type_number(value){
    var reg=/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
    if (reg.test(value) === false) {
        credential_type_number_flag=false
    }else{
        showBirthday(val)
    }
}

function showBirthday(val)
{
    var birthdayValue;
    if(15==val.length)
    { //15位身份证号码
        birthdayValue = val.charAt(6)+val.charAt(7);
        if(parseInt(birthdayValue)<10)
        {
            birthdayValue = '20'+birthdayValue;
        }
        else
        {
            birthdayValue = '19'+birthdayValue;
        }
        birthdayValue=birthdayValue+'-'+val.charAt(8)+val.charAt(9)+'-'+val.charAt(10)+val.charAt(11);
        if(parseInt(val.charAt(14)/2)*2!=val.charAt(14))
              $('#doc_gender').value='男';
//            document.all.sex.value='男';
        else
              $('#doc_gender').value='女';
//            document.all.sex.value='女';
        $('#doc_birthday').value=birthdayValue
//        document.all.birthday.value=birthdayValue;
    }
    if(18==val.length)
    { //18位身份证号码
        birthdayValue=val.charAt(6)+val.charAt(7)+val.charAt(8)+val.charAt(9)+'-'+val.charAt(10)+val.charAt(11)+'-'+val.charAt(12)+val.charAt(13);
        if(parseInt(val.charAt(16)/2)*2!=val.charAt(16))
            $('#doc_gender').value='男';
//            document.all.sex.value='男';
        else
            $('#doc_gender').value='男';
//            document.all.sex.value='女';
        if(val.charAt(17)!=IDCard(val))
        {
            document.all.idCard.style.backgroundColor='#ffc8c8';
        }
        else
        {
            document.all.idCard.style.backgroundColor='white';
        }
//        document.all.birthday.value=birthdayValue;
        $('#doc_birthday').value=birthdayValue
    }
}
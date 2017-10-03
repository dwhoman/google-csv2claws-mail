#!/usr/bin/gawk -f

BEGIN {
    RS = "(END:VCARD\nBEGIN:VCARD)|(BEGIN:VCARD)|(END:VCARD)"
    FS = "\n"
    print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
    print("<vcards>")
    image_number = 0
}

{
    print("<vcard>")
    for(i = 1; i <= NF; i++) {
	tel_pref = 0
	email_pref = 0
	field_size = match($i, "([^:]*:)(.*)", field)
	if(field_size != 0) {
	    switch(field[1]) {
	    case /EMAIL[:;]/:
		patsplit(field[1], preference, /PREF/)
		patsplit(field[1], parameters, /(WORK)|(HOME)/)
		parameters_size = length(parameters)
		preference_length = length(preference)
		print("<email>")
		print("<parameters>")
		if(preference_length > 0) {
		    email_pref++
		    print("<pref><integer>" email_pref "</integer></pref>")
		}
		if(parameters_size > 0) {
		    print("<type>")
		    for(p_s = 1; p_s <= parameters_size; p_s++) {
			print("<text>" tolower(parameters[p_s]) "</text>")
		    }
		    print("</type>")
		}
		print("</parameters>")
		print("<text>" field[2] "</text></email>")
		break
	    case /TEL[:;]/:
		patsplit(field[1], parameters, /(WORK)|(HOME)|(VOICE)|(FAX)|(MSG)|(CELL)|(PAGER)|(BBS)|(MODEM)|(CAR)|(ISDN)|(VIDEO)/)
		patsplit(field[1], preference, /PREF/)
		print("<tel>")
		parameters_size = length(parameters)
		preference_length = length(preference)
		print("<parameters>")
		if(preference_length > 0) {
		    tel_pref++
		    print("<pref><integer>" tel_pref "</integer></pref>")
		}
		if(parameters_size > 0) {
		    print("<type>")
		    for(p_s = 1; p_s <= parameters_size; p_s++) {
			print("<text>" tolower(parameters[p_s]) "</text>")
		    }
		    print("</type>")
		}
		print("</parameters>")
		print("<uri>" tolower(field[2]) "</uri></tel>")
		break
	    case /ADR[:;]/:
		adr_size = match(field[2], "([^;]*);([^;]*);([^;]*);([^;]*);([^;]*);([^;]*);(.*)", adr)
		if(adr_size != 0) {
		    patsplit(field[1], parameters, /(DOM)|(INTL)|(POSTAL)|(PARCEL)|(HOME)|(WORK)/)
		    print("<adr>")
		    parameters_size = length(parameters)
		    if(parameters_size > 0) {
			print("<parameters><type>")
			for(p_s = 1; p_s <= parameters_size; p_s++) {
			    print("<text>" tolower(parameters[p_s]) "</text>")
			}
			print("</type></parameters>")
		    }
		    print("<pobox>" name[1] "</pobox>")
		    print("<ext>" name[2] "</ext>")
		    print("<street>" name[3] "</street>")
		    print("<locality>" name[4] "</locality>")
		    print("<region>" name[5] "</region>")
		    print("<code>" name[6] "</code>")
		    print("<country>" name[7] "</country>")
		    print("</adr>")
		}
		break
	    case /ORG[:;]/:
		print("<org><text>" field[2] "</text></org>")
		break
	    case /FN[:;]/:
		print("<fn><text>" field[2] "</text></fn>")
		break
	    case /NOTE[:;]/:
		print("<note><text>" field[2] "</text></note>")
		break
	    case /PHOTO[:;]/:
	    	image = field[2]
	    	while(1) {
	    	    i++
	    	    image_part = $i
	    	    sub(/\s+/, "", image_part)
	    	    if(image_part == "") {
	    		break
	    	    } else {
	    		image = image "" image_part
	    	    }
	    	}
	    	if(image != "") {
	    	    system("echo '" image "' > /tmp/image; base64 -d /tmp/image > image_" image_number ".jpg")
	    	    print("<photo><uri>image_" image_number ".jpg</uri></photo>")
	    	    image_number++
	    	}
	    	break
	    case /TITLE[:;]/:
		print("<title><text>" field[2] "</text></title>")
		break
	    case /N[:;]/:
		name_size = match(field[2], "([^;]*);([^;]*);([^;]*);([^;]*);(.*)", name)
		if(name_size != 0) {
		    print("<n>")
		    print("<surname>" name[1] "</surname>")
		    print("<given>" name[2] "</given>")
		    print("<additional>" name[3] "</additional>")
		    print("<prefix>" name[4] "</prefix>")
		    print("<suffix>" name[5] "</suffix>")
		    print("</n>")
		}
		break
	    default:
		break
	    }
	}
    }
    print("</vcard>")
}

END {
    print("</vcards>")
}
#awk 'BEGIN { RS = "(END:VCARD\nBEGIN:VCARD)|(BEGIN:VCARD)|(END:VCARD)" ; FS = "\n" } {for(i = 1; i <= NF; i++) {match($i, "(.*):(.*)", field); print(field[1])}}' Contacts_003.vcf | sort | uniq

#output

# ADR
# ADR;ENCODING=QUOTED-PRINTABLE
# ADR;HOME
# ADR;HOME;ENCODING=QUOTED-PRINTABLE
# ADR;PREF;HOME
# ADR;PREF;HOME;ENCODING=QUOTED-PRINTABLE
# ADR;PREF;WORK
# EMAIL
# EMAIL;HOME
# EMAIL;PREF
# EMAIL;PREF;HOME
# EMAIL;PREF;WORK
# EMAIL;PREF;X-INTERNET
# EMAIL;WORK
# EMAIL;X-INTERNET
# FN
# N
# NOTE
# ORG
# PHOTO;ENCODING=BASE64;JPEG
# TEL;CELL
# TEL;CELL;PREF
# TEL;HOME
# TEL;HOME;PREF
# TEL;VOICE
# TEL;WORK
# TEL;WORK;FAX
# TEL;WORK;PREF
# TEL;X-VOICE
# TITLE
# VERSION
# X-ANDROID-CUSTOM
# X-MSN;HOME

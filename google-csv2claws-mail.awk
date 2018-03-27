function xml_attr(name, value) {
    return " " name "='" value "' "
}

function index_of(value, itter) {
    itter = 1
    while (!match(tolower(FIELDS[itter]), value) && itter <= FIELDS_len) {
	itter++
    }
    if(itter > FIELDS_len) {
	print("Field " value " not found.") > "/dev/stderr"
	exit
    } else {
	return itter
    }
}

function index_of_last(value, itter) {
    itter = FIELDS_len
    while (!match(tolower(FIELDS[itter]), value) && itter != 0) {
	itter -= 1
    }
    if(itter == 0) {
	print("Field " value " not found.") > "/dev/stderr"
	exit
    } else {
	return itter
    }
}

function sanitize(str) {
    gsub(/'/,"\\&apos;",str)
    gsub(/"/,"\\&quot;",str)
    gsub(/&/,"\\&amp;",str)
    gsub(/</,"\\&lt;",str)
    gsub(/>/,"\\&gt;",str)
    return str
}

BEGIN {
    FPAT = "([^,]*)|(\"[^\"]+\")"
    print "<?xml version='1.0' encoding='UTF-8' ?>"
    print "<address-book name='google-contacts'>"

    UID = 0
}
NR == 1 {
    CNF = NF
    split($0, FIELDS, ",")
    FIELDS_len = length(FIELDS)
    cn = index_of("name")
    first_name = index_of("given[ ]+name")
    last_name = index_of("family[ ]+name")
    nick_name = index_of("nickname")
    dob = index_of("birthday")

    groups = index_of("group[ ]+membership")

    email_first = index_of("e-mail")
    email_last = index_of_last("e-mail")
    email_1_last = index_of_last("e-mail")
    email_field_num = email_1_last - email_first + 1
    email_count = (email_last - email_first + 1)/email_field_num

    phone_first = index_of("phone")
    phone_last = index_of_last("phone")
    phone_1_last = index_of_last("phone[ ]+1")
    phone_field_num = phone_1_last - phone_first + 1
    phone_count = (phone_last - phone_first + 1)/phone_field_num

    physical_address_first = index_of("address")
    physical_address_last = index_of_last("address")
    physical_address_1_last = index_of_last("address[ ]+1")
    physical_address_field_num = physical_address_1_last - physical_address_first + 1
    physical_address_count = (physical_address_last - physical_address_first + 1)/physical_address_field_num

    organization_first = index_of("organization")
    organization_last = index_of_last("organization")
    organization_1_last = index_of_last("organization[ ]+1")
    organization_field_num = organization_1_last - organization_first + 1
    organization_count = (organization_last - organization_first + 1)/organization_field_num

    website_first = index_of("website")
    website_last = index_of_last("website")
    website_1_last = index_of_last("website[ ]+1")
    website_field_num = website_1_last - website_first + 1
    website_count = (website_last - website_first + 1)/website_field_num
}

NR != 1 && NF == CNF {
    print "<person" \
	xml_attr("uid", UID++) \
	xml_attr("first-name", sanitize($first_name))	\
	xml_attr("last-name", sanitize($last_name))	\
	xml_attr("nick-name", sanitize($nick_name))	\
	xml_attr("cn", sanitize($cn)) ">"
    # email address
    print "<address-list>"
    for(i = 1; i <= email_count; i++) {
	print "<address" \
	    xml_attr("uid", UID++) \
	    xml_attr("email", sanitize($(index_of("e-mail[ ]+" i "[ ]+-[ ]+value")))) \
	    xml_attr("remarks", sanitize($(index_of("e-mail[ ]+" i "[ ]+-[ ]+type")))) "/>"
    }
    print "</address-list>"
    # other addresses
    print "<attribute-list>"
    for(i = 1; i <= phone_count; i++) {
	print "<attribute" xml_attr("uid", UID++) xml_attr("name", "phone") ">"
	print sanitize($(index_of("phone[ ]+" i "[ ]+-[ ]+value")))
	print "</attribute>"
    }
    for(i = 1; i <= physical_address_count; i++) {
	print "<attribute" xml_attr("uid", UID++) xml_attr("name", "address") ">"
	print sanitize($(index_of("address[ ]+" i "[ ]+-[ ]+formatted")))
	print "</attribute>"
    }

    # TODO: mobile phone, organization, office phone, office address, fax, website

    print "<attribute " xml_attr("uid", UID++) xml_attr("name", "date of birth") ">"
    print sanitize($dob)
    print "</attribute>"
    print "</attribute-list>"
    print "</person>"

    # TODO: groups
}

NF != CNF {
    print "Line " NR ", expected " CNF " fields, got " NF " fields." > "/dev/stderr"
}

END {
    print "</address-book>"
}

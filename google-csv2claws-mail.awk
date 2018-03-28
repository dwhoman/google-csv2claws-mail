#!/usr/bin/gawk -f

# This is free and unencumbered software released into the public domain.

# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# For more information, please refer to <http://unlicense.org/>

function sanitize(str) {
    gsub(/'/,"\\&apos;",str)
    gsub(/"/,"\\&quot;",str)
    gsub(/&/,"\\&amp;",str)
    gsub(/</,"\\&lt;",str)
    gsub(/>/,"\\&gt;",str)
    return str
}

function xml_attr(name, value) {
    return " " name "='" sanitize(value) "' "
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

function cm_attribute(value, name) {
    if(value) {
	return "<attribute" xml_attr("uid", UID++) xml_attr("name", name) ">" sanitize(value) "</attribute>"
    } else {
	return ""
    }
}

BEGIN {
    FPAT = "([^,]*)|(\"[^\"]+\")"
    if(!NAME) {
	NAME = "google-contacts"
    }
    print "<?xml version='1.0' encoding='UTF-8' ?>"
    print "<address-book" xml_attr("name", NAME) ">"

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
    email_1_last = index_of_last("e-mail[ ]+1")
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
    person_id = UID++
    print "<person" \
	xml_attr("uid", person_id) \
	xml_attr("first-name", $first_name)	\
	xml_attr("last-name", $last_name)	\
	xml_attr("nick-name", $nick_name)	\
	xml_attr("cn", $cn) ">"
    # email address
    print "<address-list>"
    for(i = 1; i <= email_count; i++) {
	print "<address" \
	    xml_attr("uid", UID++) \
	    xml_attr("email", $(index_of("e-mail[ ]+" i "[ ]+-[ ]+value"))) \
	    xml_attr("remarks", $(index_of("e-mail[ ]+" i "[ ]+-[ ]+type"))) "/>"
	if(i == 1) {
	    # for group association
	    address_id = UID - 1
	}
    }
    print "</address-list>"
    # other addresses
    print "<attribute-list>"
    for(i = 1; i <= phone_count; i++) {
	print cm_attribute($(index_of("phone[ ]+" i "[ ]+-[ ]+value")), "phone")
    }
    for(i = 1; i <= physical_address_count; i++) {
	print cm_attribute($(index_of("address[ ]+" i "[ ]+-[ ]+formatted")), "address")
    }

    cm_attribute($dob, "date of birth")
    print "</attribute-list>"
    print "</person>"

    split($groups, curr_groups, " ::: ")
    for(group in curr_groups) {
	all_groups[curr_groups[group]] = all_groups[curr_groups[group]] "<member" xml_attr("pid",person_id) xml_attr("eid",address_id) "/>"
    }
}

NF != CNF {
    print "Line " NR ", expected " CNF " fields, got " NF " fields." > "/dev/stderr"
}

END {
    for(group in all_groups) {
	print "<group" xml_attr("uid",UID++) xml_attr("name",group) xml_attr("remarks","") ">"
	print "<member-list>"
	print all_groups[group]
	print "</member-list>"
	print "</group>"
    }
    print "</address-book>"
}

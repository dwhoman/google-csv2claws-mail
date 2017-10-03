#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Std;
use XML::Writer;
use IO::File;


my $vb = {
	  CR => "\r",
	  LF =>"\n",
	  CRLF => "\r\n",
	  SPACE => " ",
	  HTAB => "\t",
	  ws => "[ \t]+",
	  wsls => "[ \t\r\n]+",
	  word => "[-0-9A-Za-z!\"%&'()*+/;<>?_]+"
	 };
$vb{"groups"} = "(" . $vb{"word"} . "\.)*" . $vb{"word"};
$vb{"vcard_file"} = "(" . $vb{"wsls"} . ")?" . $vb{"vcard"} . "(" . $vb{"wsls"} . ")?";
$vb{"vcard"} = "BEGIN" . $vb{"ws"} . ":" . $vb{"ws"} . "VCARD" . $vb{"ws"} . $vb{"CRLF"} . "+" .
  $vb{"items"} . $vb{"CRLF"} . "*END" . $vb{"ws"} “:” [ws] “VCARD”;
items		= items *CRLF item
		/ item
	; these may be “folded”
item		= [groups “.”] name
		  [params] “:” value CRLF
		/ [groups “.”] “ADR”
		  [params] “:” addressparts CRLF
		/ [groups “.”] “ORG”
		  [params] “:” orgparts CRLF
		/ [groups “.”] “N”
		  [params] “:” nameparts CRLF
		/ [groups “.”] “AGENT”
		  [params] “:” vcard CRLF
	; these may be “folded”
name		= “LOGO” / “PHOTO” / “LABEL” / “FN” / “TITLE”
		/ “SOUND” / “VERSION” / “TEL” / “EMAIL” / “TZ” / “GEO” / “NOTE”
		/ “URL” / “BDAY” / “ROLE” / “REV” / “UID” / “KEY”
		/ “MAILER” / “X-” word 
	; these may be “folded”
value		= 7bit / quoted-printable / base64
7bit		= <7bit us-ascii printable chars, excluding CR LF>
8bit		= <MIME RFC 1521 8-bit text>
quoted-printable = <MIME RFC 1521 quoted-printable text>
base64		= <MIME RFC 1521 base64 text>
	; the end of the text is marked with two CRLF sequences
	; this results in one blank line before the start of the next property
params		= “;” [ws] paramlist
paramlist	= paramlist [ws] “;” [ws] param
		/ param
param		= “TYPE” [ws] “=“ [ws] ptypeval
		/ “VALUE” [ws] “=“ [ws] pvalueval
		/ “ENCODING” [ws] “=“ [ws] pencodingval
		/ “CHARSET” [ws] “=“ [ws] charsetval
		/ “LANGUAGE” [ws] “=“ [ws] langval
		/ “X-” word [ws] “=“ [ws] word
		/ knowntype
ptypeval	= knowntype / “X-” word
pvalueval	= “INLINE” / “URL” / “CONTENT-ID” / “CID” / “X-” word
pencodingval 	= “7BIT” / “8BIT” / “QUOTED-PRINTABLE” / “BASE64” / “X-” word
charsetval	= <a character set string as defined in Section 7.1 of 
		RFC 1521>
langval		= <a language string as defined in RFC 1766>
addressparts	= 0*6(strnosemi “;”) strnosemi
	; PO Box, Extended Addr, Street, Locality, Region, Postal Code,
	Country Name
orgparts	= *(strnosemi “;”) strnosemi
	; First is Organization Name, remainder are Organization Units.
nameparts	= 0*4(strnosemi “;”) strnosemi
	; Family, Given, Middle, Prefix, Suffix.
	; Example:Public;John;Q.;Reverend Dr.;III, Esq.
strnosemi	= *(*nonsemi (“\;” / “\” CRLF)) *nonsemi
	; To include a semicolon in this string, it must be escaped
	; with a “\” character.
nonsemi		= <any non-control ASCII except “;”>
knowntype	= “DOM” / “INTL” / “POSTAL” / “PARCEL” / “HOME” / “WORK”
		/ “PREF” / “VOICE” / “FAX” / “MSG” / “CELL” / “PAGER”
		/ “BBS” / “MODEM” / “CAR” / “ISDN” / “VIDEO”
		/ “AOL” / “APPLELINK” / “ATTMAIL” / “CIS” / “EWORLD”
		/ “INTERNET” / “IBMMAIL” / “MCIMAIL”
		/ “POWERSHARE” / “PRODIGY” / “TLX” / “X400”
		/ “GIF” / “CGM” / “WMF” / “BMP” / “MET” / “PMB” / “DIB”
		/ “PICT” / “TIFF” / “PDF” / “PS” / “JPEG” / “QTIME”
		/ “MPEG” / “MPEG2” / “AVI”
		/ “WAVE” / “AIFF” / “PCM”
		/ “X509” / “PGP”
		};

use vars qw/$opt_i $opt_o/;
getopts('i:o:');

my $fh_o = undef;
my $fh_i = undef;

if(defined $opt_o) {
  # output to file
  $fh_o = IO::File->new();
  $fh_o->open(">" . $opt_o) || die "Unable to open file $opt_o\n";
} 
# else output to STDOUT

if(defined $opt_i) {
  $fh_i = IO::File->new();
  $fh_i->open("<" . $opt_i) || die "Unable to open file $opt_i\n";
} 
# else input from STDIN

my $xcardns = "urn:ietf:params:xml:ns:vcard-4.0";
my $xcards = XML::Writer->new(NAMESPACES => 1, OUTPUT => $fh_o, ENCODING => 'utf-8');
$xcards->startTag([$vcardns, "vcards"]);

$xcards->doctype("xml");

foreach 

$xcards->endTag("vcards");

$xcards->end();

if(defined $fh_o) {
  $fh_o->close;
}

if(defined $fh_i) {
  $fh_i->close;
}

(import [sys])
(sys.path.append "./vcard/vcard")
(import [vcard.vcard_utils]
        [vcard.vcard_errors]
        [vcard.vcard_property]
        [vcard.vcard_definitions]
        [vcard.vcard_validators]
        [vcard.vcard_validator] ;contains the VCard class
        [vcard]
        [xmlgen]
        [xmlgen_helpes]
        [xcard])

(defmain [&rest args]
  "Convert a vcard file into an xcard file. vcard files can contain
  base64 encoded images. The default is to ignore these images. If the
  image is external to the vcard, then the link is copied. The default
  output is stdout.

   vcard2xcard [OPTION...] SRC

   -o :: output file

   -e :: Embed images in the xml output.

   -i :: Image directory.  The default directory is the current
         directory. Linked image paths will be unchanged. Cannot be used with
         the -e option.
  ")

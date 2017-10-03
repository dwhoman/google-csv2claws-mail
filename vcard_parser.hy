(import [datetime sys os re])

(defclass VCardProperty []
  [[--init-- (fn [self tag value &rest parameters]
               (def self.tag tag)
               (def self.value value)
               (def self.parameters parameters)
               None)]])

;;; TODO: tokenize by breaking the file up first be BEGIN/END blocks,
;;; then by colons. Check for escaped colons and re-append where
;;; necessary. Then break those blocks up by semicolons and re-append
;;; where necessary.

;; \; is not a delimiter because it is escaped unless \\;
(def property-delimiter "^(?:[^\\]?(\\\\)*);"
)
(def address (VCardProperty "adr" "[^;]+(;[^;]+)*")
  birthday None
  email None
  fn None
  geo None
  key None
  label None
  logo None
  name None
  note None
  org None
  photo None
  rev None
  role None
  sound None
  source None
  tel None
  title None
  tz None
  uid None
  url None
  version None
  impp None ;rtc 4770 extension
   )

(defclass VCard []
  [[[parameter-start ";"]
    [value-start ":"]
    [start "^\s*begin\s*:\s*vcard\s*$"]
    [end "^\s*end\s*:\s*vcard\s*$"]]
   [--init-- (fn [self &rest properties]
               (def self.adr address))]])

(defclass VCard21 [VCard])

(defclass VCard3 [VCard])

(defclass VCard4 [VCard])

(defclass VCard6474 [VCard4])

(defclass VCard6715 [VCard4])

(defclass )

\;
\\;
\\\;
\\\\;

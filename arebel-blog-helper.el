(defun arebel-upload-journal-entry ()
  "Convert a org-journal entry into a Pelican blog entry by parsing the entry and then calling a Python script that does the conversion."
  (interactive)
  (let* ((title (read-string "Enter title: "))
	 (slug (replace-regexp-in-string " " "-" (replace-regexp-in-string "-" " " title)))
	 (time (nth 4 (org-heading-components)))
	 (tags (nth 5 (org-heading-components)))
	 (content (org-get-entry))
	 (date (progn (outline-up-heading 1)
		      (nth 4 (org-heading-components))))	)
    (shell-command
     (format "%s %s %s %s %s %s %s"
	     "arebel-blog-helper"
	     (concat "\"" title "\"")
	     (concat "\"" slug "\"")
	     (concat "\"" date "\"")
	     (concat "\"" time "\"")
	     (concat "\"" tags "\"")
	     (concat "\"" content "\"")))
    (find-file (concat "~/blog/karlo.licudine.me/content/" slug ".md"))))

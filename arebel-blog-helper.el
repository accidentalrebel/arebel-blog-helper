(defun arebel-upload-journal-entry ()
  "Convert a org-journal entry into a Pelican blog entry by parsing the entry and then calling a Python script that does the conversion."
  (interactive)
  (let* ((title (read-string "Enter title: "))
	 (slug (replace-regexp-in-string " " "-" (replace-regexp-in-string "-" " " title)))
	 (time (nth 4 (org-heading-components)))
	 (tags (nth 5 (org-heading-components)))
	 (content (org-get-entry))
	 (date (progn (outline-up-heading 1)
		      (nth 4 (org-heading-components)))))
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

(defun arebel-insert-image ()
  "Insert the selected file into the blog article.  It automatically copies the file into the correct image folder."
  (interactive)
  (let* ((file-path (read-file-name "Get file name:"))
	 (full-file-name (car (last (split-string file-path "/"))))
	 (file-name (car (split-string full-file-name "\\."))))
    (message "fullfilename: %s" full-file-name)
    (message "filename: %s" file-name)
    (insert (concat "![" file-name "]({attach}/images/" full-file-name ")"))
    (copy-file file-path (concat "~/blog/karlo.licudine.me/content/images/" full-file-name))))

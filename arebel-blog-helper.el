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
  (let* ((file-path (read-file-name "Get file name: "))
	 (file-name (read-string "File name to use: "))
	 (extension (car (cdr (split-string (car (last (split-string file-path "/"))) "\\."))))
	 (target-file-path (concat "~/blog/karlo.licudine.me/content/images/" file-name "." extension)))
    (insert (concat "![" file-name "]({attach}/images/" file-name "." extension ")"))
    (copy-file file-path target-file-path)
    (shell-command (concat "convert " target-file-path " -resize 500x500\\> " target-file-path))
    ))

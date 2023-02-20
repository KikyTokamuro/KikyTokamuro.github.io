;;; publish.el --- Make site
;; Author: Arhangelsky Daniil (Kiky Tokamuro) <kiky.tokamuro@yandex.ru>
;;; Commentary:
;;; Code:

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package htmlize)
(use-package ox-publish)

(setq system-time-locale "C"
      org-html-htmlize-output-type 'css
      org-export-date-timestamp-format "%d %B %Y"
      org-html-metadata-timestamp-format "%d %B %Y"
      org-html-validation-link nil
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-html-head "
          <link rel=\"icon\" href=\"./static/favicon.ico\">
          <link rel=\"stylesheet\" href=\"./static/org.css\" />
      "
      org-export-creator-string (format "Made with <a href=\"https://www.gnu.org/software/emacs/\">Emacs</a> %s (<a href=\"https://orgmode.org/\">Org</a> mode %s)"
					emacs-version
					(org-release)))

(setq org-publish-project-alist
      `(("notes"
         :base-directory "./content/notes"
         :publishing-function org-html-publish-to-html
         :publishing-directory "../notes/"
         :with-author nil
	 :creator ,org-export-creator-string
         :with-creator t
         :with-toc t
	 :with-date nil
         :section-numbers nil
         :time-stamp-file nil)
	("pages"
	 :base-directory "./content"
         :publishing-function org-html-publish-to-html
         :publishing-directory "../"
         :with-author nil
	 :creator ,org-export-creator-string
         :with-creator t
         :with-toc nil
	 :with-date nil
         :section-numbers nil
         :time-stamp-file nil)
	("static"
	 :recursive t
         :base-directory "./static"
         :base-extension "css\\|txt\\|jpg\\|gif\\|png\\|ico\\|glb"
         :publishing-directory  "../static/"
         :publishing-function org-publish-attachment)
	("kikytokamuro.space"
	 :components ("static" "pages" "notes"))))

(org-publish "kikytokamuro.space" t)

(provide 'publish)
;;; publish.el ends here

(in-package :hawksbill.utils)

(defmacro ck-js (lang)
  `(fmtnil (<:script :type "text/javascript"
                     :src "/static/ckeditor/ckeditor.js")
           (<:script :type "text/javascript"
                     :src "/static/ckeditor/adapters/jquery.js")
           (<:script :type "text/javascript"
                     (fmtnil "$('.ckeditor td textarea').ckeditor();"))
           ;; http://ckeditor.com/forums/FCKeditor-2.x/Change-default-font-editor
           (unless (string= "en-IN" ,lang)
             (<:script :type "text/javascript" "
CKEDITOR.on('instanceReady', function(e) {
    e.editor.document.getBody().setStyle('font-family', 'Lohit Devanagari');
    e.editor.on('mode', function(a) {
        if (a.data.previousMode == 'source') {
            a.editor.document.getBody().setStyle('font-family', 'Lohit Devanagari');
        } else { // a.data.previousMode == 'wysiwyg'
            a.editor.textarea.setStyle('font-family', 'Lohit Devanagari');
        }
    });
});
"))))

;; remove empty :p and :div tags
;; remove ""
(defun cleanup-ckeditor-text (body)
  (regex-replace-all "<p>
	&nbsp;</p>" (regex-replace-all "<div>
	&nbsp;</div>" (regex-replace-all "" body "") "") ""))

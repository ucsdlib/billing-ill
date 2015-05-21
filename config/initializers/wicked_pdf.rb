if Rails.env.development?
  WickedPdf.config = {
    #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
    #:layout => "pdf.html",
    exe_path: '/usr/local/bin/wkhtmltopdf'
  }
end

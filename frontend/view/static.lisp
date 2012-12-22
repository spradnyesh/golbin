(in-package :hawksbill.golbin.frontend)

(defun v-tos ()
  (fe-page-template
      "Terms of Service"
      nil
      nil
      nil
    (htm (:div :id "static"
               (:h3 "Terms of Service")
               (:div (:h4 "Important Information")
                     (:p "You should carefully read the following Terms and Conditions. Your use of our content implies that you have read and accepted these Terms and Conditions."))
               (:div (:h4 "Ownership")
                     (:p "You may not claim intellectual or exclusive ownership to any of our content, modified or unmodified. All contents are property of independent content providers. Our contents are provided \"as is\" without warranty of any kind, either expressed or implied. In no event shall our juridical person be liable for any damages including, but not limited to, direct, indirect, special, incidental or consequential damages or other losses arising out of the use of or inability to use our content."))
               (:div (:h4 "Unauthorized Use")
                     (:p "You may not place any of our content, modified or unmodified, on a diskette, CD, website or any other medium and offer them for redistribution or resale of any kind without prior written consent from the company and the author of the content."))
               (:div (:h4 "Intellectual Property Rights Policy")
                     (:p "Golb.in provides content created and submitted by freelance authors. We encourage intellectual property rights owners to " (:a :href "mailto:webmaster@golb.in" "contact us") " if they believe that a designer has infringed their rights.")
                     (:p "If you let us know that your rights are being infringed by one of our authors we will (in our discretion) remove the content in question from our website and, if the author continues to infringe your rights (or infringes the rights of others) terminate our agreement with the author.")
                     (:p "If you believe that your intellectual property rights have been infringed by one of our authors, please provide us with a notification that contains the following information:")
                     (:ul (:li "A physical or electronic signature of a person authorized to act on behalf of the owner of the copyright or other rights that have been allegedly infringed.")
                          (:li "Identification of the copyright, trademark or other rights that have been allegedly infringed.")
                          (:li "The URL used in connection with the allegedly infringing merchandise. Note that simply including \"www.golb.in\" is not sufficient to identify what you are objecting to; please include links to specific content.")
                          (:li "Your name, address, telephone number and email address.")))
               (:div (:h4 "Change to these terms")
                     (:p "Our company reserves the right to change or modify current Terms of Service with no prior notice."))
               (:div (:h4 "Questions and Suggestions")
                     (:p "If you have questions or suggestions about the Terms of Service, please " (:a :href "mailto:webmaster@golb.in" "contact us") "."))))))

(defun v-privacy ()
  (fe-page-template
      "Privacy"
      nil
      nil
      nil
    (htm (:div :id "static"
               (:h3 "Privacy")
               (:p "Golb.in (hereafter referred to as Company) has created this privacy policy to demonstrate our commitment to the privacy of the users of our websites. Please read the following to learn more about our privacy policy, and how we treat personally identifiable information collected from our visitors and users.")
               (:div (:h4 "What this privacy policy covers")
                     (:p "This privacy policy covers Company's treatment of personally identifiable information collected by Company through a website owned and operated by Company.")
                     (:p "This privacy policy does not apply to the practices of companies that Company does not own or control, or of persons that Company does not employ or manage, including any third-party content contributors bound by contract and any third-party websites to which Company's websites link."))
               (:div (:h4 "Collection and use of personal information")
                     (:p "You can visit the websites of Company without revealing any personal information. However, Company needs certain information if you wish to submit your content, register for an author account, or use certain Company services.")
                     (:p "Where required, this information may include your personal contact information. Company will use this information to reply to your inquiries, to provide you with request services, to set up your member's account, and to contact you regarding new products and services.")
                     (:p "By accessing the services of Company and voluntarily providing us with the requested personal information, you consent to the collection and use of the information in accordance with the privacy policy."))
               (:div (:h4 "Collection and use of non-personal information")
                     (:p "Company automatically receives and records non-personal information on over server logs from your browser including your IP address, cookie information and the page you requested. Company may use this information to customize the advertising and content you see and to fulfill your request for certain products and services. However, Company does not connect this non-personal data to any personal information collected from you.")
                     (:p "Company also allows third party companies that are presenting advertisement on some of our pages to set and access their cookies on your computer. Again, these cookies are not connected to any personal information. Third party cookie usage is subject to their own privacy policy, and Company assumes no responsibility or liability for this usage."))
               (:div (:h4 "Information sharing and disclosure")
                     (:p "Company may disclose your personal information to third parties who work on behalf of Company to provide products and services requested by you. We will share personal information for these purposes only with third parties whose privacy policies are consistent with ours or who agree to abide by our policies with respect to personal information.")
                     (:p "Company may otherwise disclose your personal information when:")
                     (:ul (:li "We have your express consent to share the information for a specified purpose;")
                          (:li "We need to respond to subpoenas, court orders or such other legal process;")
                          (:li "We need to protect the personal safety of the users of our websites or defend the rights or property of Company;")
                          (:li "We find that actions on our websites violate the Company \"Terms of Service\" document or any of our usage guidelines for specific products or services.")))
               (:div (:h4 "Consent")
                     (:p "If you do not consent to the collection, use or disclosure of your personal information as outlined in the policy, please do not provide any personal information to Company. If you have provided personal information to Company and no longer consent to its use or disclosure as outlined herein, please " (:a :href "mailto:webmaster@golb.in" "contact us")"."))
               #|(:div (:h4 "Security")
               (:p "Unfortunately, no data transmission over the Internet can be considered 100% secure. However, our Company Information protected for your privacy and security. In certain areas of our websites, as identified on the site, Company uses industry-standard SSL-encryption to protect data transmissions.")
               (:p "We also safeguard your personal information from unauthorized access, through access control procedures, network firewalls and physical security measures.
")
               (:p "Further, Company retains your personal information only as long as necessary to fulfill the purposes identified above or as required by law."))|#
              (:div (:h4 "Changes to the privacy policy")
                    (:p "Company may at any time, without notice to you and in its sole discretion, amend this policy from time to time. Please review this policy periodically. Your continued use of Company websites after any such amendments signifies your acceptance thereof."))
              (:div (:h4 "Questions and Suggestions")
                    (:p "If you have questions or suggestions about the Terms of Service, please " (:a :href "mailto:webmaster@golb.in" "contact us") "."))))))

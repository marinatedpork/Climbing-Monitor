test = ["/v/ziggies-day-out/105749095",
"/v/checkerboard-crack/105749110",
"/v/backflip/105749083",
"/v/romulan-territory/105749074",
"/v/between-the-sheets/105752644",
"/v/jaws/105749368",
        "<div></div>",
    "</td>",
"</tr></table><a name=",
"/v/coachs-demise/105757933",
"/v/cross-country/105759486",
"/v/crossfire/106247599",
"/v/derek-tissima/105764385",
"/v/direct-north-face/105749743"]
def clean_file(links)
  links.delete_if { |link| (link =~ /\/v\/(.+)?\/\d{9}/).nil? }
  return links
end
 =~ /\/v\/(.+)?\/\d{9}/).nil?

{
function TAB()
    if you.class() == "Conjurer" or you.class() == "Fire Elementalist" or you.class() == "Air Elementalist" or you.class() == "Earth Elementalist" then
        crawl.sendkeys("zaf")
    else
        crawl.do_commands({'CMD_AUTOFIGHT_NOMOVE'})
    end
end
}
macros += M \{9} ===TAB

// copy https://code.luasoftware.com/tutorials/hugo/how-to-create-link-with-target-blanks-in-hugo-markdown/

var links = document.getElementsByTagName('a');
for (var i = 0, linksLength = links.length; i < linksLength; i++) {
    if (links[i].hostname != window.location.hostname) {
        links[i].target = '_blank';
        links[i].rel = 'noopener noreferrer';
    };
};

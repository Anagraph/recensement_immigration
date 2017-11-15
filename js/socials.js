function fbshareCurrentPage()
    {window.open("https://www.facebook.com/sharer/sharer.php){}u="+escape(window.location.href)+"&t="+document.title, '',
    'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=300,width=600');
    return false; }

function tweetCurrentPage()
            {window.open("https://twitter.com/intent/tweet){}title="+document.title+' par Anagraph_geo  '+'&text=Recensement 2016 - Immigration et lieux de naissance'+escape(window.location.href),'',
            'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=300,width=600');
            return false; }

 function linkedCurrentPage()
            {window.open("https://www.linkedin.com/shareArticle){}mini=true&url="+escape(window.location.href)+'&summary='+document.title+'&source=linkedIn', '',
            'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=300,width=600');
            return false; }

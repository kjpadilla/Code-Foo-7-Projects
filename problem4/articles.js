window.onload = initAll;

var displayingAnotherLink = false;

/* This function grabs all the data that is needed from the API.
The function stores this data in initialArticleList and sends the 
correct pieces of data to the function addArticleListElement.
The addArticleListElement function dynamically constructs each 
list element and is called 10 times when the page is first loaded */
function initAll()
{
	$.ajax
	({
		url: 'http://ign-apis.herokuapp.com/articles?startIndex=0&count=10',
		dataType: 'jsonp',
		type: 'get',
		success: function(initialArticleList)
		{
			console.log(initialArticleList.data[0]);
			for (var i = 0; i < initialArticleList.data.length; i++)
			{
					addArticleListElement(initialArticleList.data[i].metadata.headline,
					initialArticleList.data[i].thumbnails[2].url, initialArticleList.data[i].metadata.slug,
					initialArticleList.data[i].metadata.subHeadline, i);
			}				
		}		
	});
}


/* This is the function that dynamically creates the buttons that are clicked
to display links to the IGN website. The neccessary data to do this is passed 
to this function from a request to the API. A 0 is placed before the first 9 
list elements */
function addArticleListElement(articleHeadline, articleImage, articleLink, articleSubHeadline, articleNumber)
{
	var newArticleElement = document.createElement('li');
	var buttonToLink = document.createElement('button');
	buttonToLink.setAttribute('id', 'article'+ articleNumber);
	buttonToLink.setAttribute('data-image', articleImage);
	buttonToLink.setAttribute('data-link', articleLink);
	buttonToLink.setAttribute('data-subHeadline', articleSubHeadline);
	buttonToLink.setAttribute('onclick', 'showLinkToArticle(this.id, this.parentElement.childElementCount)');
	
	if (articleNumber < 9)
	{
		var contentOfTag = document.createTextNode("\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A00" + 
		++articleNumber + "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0" + articleHeadline);
	}
	else
	{
		var contentOfTag = document.createTextNode("\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0" + 
		++articleNumber + "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0" + articleHeadline);
	}
	buttonToLink.appendChild(contentOfTag);
	
	newArticleElement.appendChild(buttonToLink);
	document.getElementById("ignArticleList").appendChild(newArticleElement);
}


/* This function is called when one of the buttons in the list is clicked. 
It dynamically creates an anchor with a child image. This anchor is made a child
of the clicked button's parent. The correct image is determined by the unique article
number associated with the clicked button. */
function showLinkToArticle(articleID, displaying)
{
	var currentArticleTab = document.getElementById(articleID);
	var parentListElement = document.getElementById(articleID).parentElement;
	
	if(displaying == 1 && !displayingAnotherLink)
	{
		var img = document.createElement('img');
		var anchorToArticle = document.createElement('a');
		
		anchorToArticle.setAttribute('class', 'displayingAnchor');
		anchorToArticle.setAttribute('href', "https://www.ign.com/articles/" + currentArticleTab.dataset.link);
		img.src = currentArticleTab.dataset.image;
		anchorToArticle.appendChild(img);
		
		parentListElement.appendChild(anchorToArticle);
		
		displayingAnotherLink = true;
		displayingLinkId = articleID;
	}
	else if (displaying != 1)
	{
		parentListElement.removeChild(parentListElement.lastChild);
		displayingAnotherLink = false;
	}
	else
	{
		var displayingParent = document.getElementById(displayingLinkId).parentElement;
		displayingParent.removeChild(displayingParent.lastElementChild);
		
		var img = document.createElement('img');
		var anchorToArticle = document.createElement('a');
		
		anchorToArticle.setAttribute('class', 'displayingAnchor');
		anchorToArticle.setAttribute('href', "https://www.ign.com/articles/" + currentArticleTab.dataset.link);
		img.src = currentArticleTab.dataset.image;
		anchorToArticle.appendChild(img);
	
		parentListElement.appendChild(anchorToArticle);
		
		displayingAnotherLink = true;
		displayingLinkId = articleID;
	}
}


/* This function makes another request to the API when the "SEE MORE" button is clicked
and sends data to the addArticleListElement function. The addArticleListElement then appends
5 new article buttons to the current list.  This is exactly the same as the first function 
except only 5 articles are pulled and the startIndex is different*/
function loadMoreArticles()
{
	
	var numberOfArticles = document.getElementById("ignArticleList").childElementCount;
	
	$.ajax
	({
		url: 'http://ign-apis.herokuapp.com/articles?startIndex=' + numberOfArticles +'&count=5',
		dataType: 'jsonp',
		type: 'get',
		success: function(initialArticleList)
		{
			console.log(initialArticleList.data[0]);
			for (var i = 0; i < initialArticleList.data.length; i++)
			{
				console.log(initialArticleList.data[i].metadata.headline + " " + i);
				addArticleListElement(initialArticleList.data[i].metadata.headline,
				initialArticleList.data[i].thumbnails[2].url, initialArticleList.data[i].metadata.slug,
				initialArticleList.data[i].metadata.subHeadline, numberOfArticles + i);
			}				
		}		
	});
}
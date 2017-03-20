window.onload = initAll;

var displayingAnotherLink = false;

/* This function grabs all the data that is needed from the API.
The function stores this data in initialVideoList and sends the 
correct pieces of data to the function addVideoListElement.
The addVideoListElement function dynamically constructs each 
list element and is called 10 times when the page is first loaded  */
function initAll()
{
	$.ajax
	({
		url: 'http://ign-apis.herokuapp.com/videos?startIndex=0&count=10',
		dataType: 'jsonp',
		type: 'get',
		success: function(initialVideoList)
		{
			console.log(initialVideoList.data[0]);
			for (var i = 0; i < initialVideoList.data.length; i++)
			{
					addVideoListElement(initialVideoList.data[i].metadata.name, 
					initialVideoList.data[i].thumbnails[2].url, initialVideoList.data[i].metadata.url, 
					initialVideoList.data[i].metadata.duration, i);
			}				
		}		
	});
}

/* This is the function that dynamically creates the buttons that are clicked
to display links to the IGN website. The neccessary data to do this is passed 
to this function from a request to the API. A 0 is placed before the first 9 
list elements and in front of the seconds value when seconds < 10 */
function addVideoListElement(videoTitle, videoImage, videoLink, videoDuration, videoNumber)
{	
	var newVideoElement = document.createElement('li');
	var buttonToLink = document.createElement('button');
	buttonToLink.setAttribute('id', 'video'+ videoNumber);
	buttonToLink.setAttribute('data-image', videoImage);
	buttonToLink.setAttribute('data-link', videoLink);
	buttonToLink.setAttribute('data-duration', videoDuration);
	buttonToLink.setAttribute('onclick', 'showLinkToVideo(this.id, this.parentElement.childElementCount)');
	
	
	var seconds = getSeconds(videoDuration);
	if(videoNumber < 9)
	{
		if(seconds < 10)
		{
			var contentOfTag = document.createTextNode("\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A00" + 
			++videoNumber + "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0" + videoTitle + " " +
			getMinutes(videoDuration) + ":0" + getSeconds(videoDuration));
		}
		else
		{
			var contentOfTag = document.createTextNode("\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A00" + 
			++videoNumber + "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0" + videoTitle + " " +
			getMinutes(videoDuration) + ":" + getSeconds(videoDuration));
		}
	}
	else
	{
		if(seconds < 10)
		{
			var contentOfTag = document.createTextNode("\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0" + 
			++videoNumber + "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0" + videoTitle + " " +
			getMinutes(videoDuration) + ":0" + getSeconds(videoDuration));
		}
		else
		{
			var contentOfTag = document.createTextNode("\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0" + 
			++videoNumber + "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0" + videoTitle + " " +
			getMinutes(videoDuration) + ":" + getSeconds(videoDuration));
		}
	}
	
	buttonToLink.appendChild(contentOfTag);
	
	newVideoElement.appendChild(buttonToLink);
	document.getElementById("ignVideoList").appendChild(newVideoElement);
}

/* This function returns the number of full-minutes of a video when given the 
duration value returned by the API. There seems to be a special case where 
the duration value is given in 1/60th of seconds. I determined this to be whenever
the value exceeded 3600 */
function getMinutes(seconds)
{
	if (seconds < 3600)
	{
		return Math.floor(seconds/60);
	}
	else
	{
		return Math.floor(seconds/3600);
	}
}

/* This function returns the number of left-over seconds in video
when given the duration value returned by the API. */
function getSeconds(seconds)
{
	if (seconds < 3600)
	{
		return (seconds%60);
	}
	else
	{
		return Math.floor((seconds/3600 - 1) * 60);
	}
}


/* This function is called when one of the buttons in the list is clicked. 
It dynamically creates an anchor with a child image. This anchor is made a child
of the clicked button's parent. The correct image is determined by the unique video
number associated with the clicked button */
function showLinkToVideo(videoID, displaying)
{
	var currentVideoTab   = document.getElementById(videoID);
	var parentListElement = document.getElementById(videoID).parentElement;
	
	if(displaying == 1 && !displayingAnotherLink)
	{
		var img = document.createElement('img');
		var anchorToVideo = document.createElement('a');
		
		anchorToVideo.setAttribute('class', 'displayingAnchor');
		anchorToVideo.setAttribute('href', currentVideoTab.dataset.link);
		img.src = currentVideoTab.dataset.image;
		anchorToVideo.appendChild(img);
		
		parentListElement.appendChild(anchorToVideo);
		
		displayingAnotherLink = true;
		displayingLinkId = videoID;
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
		var anchorToVideo = document.createElement('a');
		
		anchorToVideo.setAttribute('class', 'displayingAnchor');
		anchorToVideo.setAttribute('href', currentVideoTab.dataset.link);
		img.src = currentVideoTab.dataset.image;
		anchorToVideo.appendChild(img);
		
		parentListElement.appendChild(anchorToVideo);
		
		displayingAnotherLink = true;
		displayingLinkId = videoID;
	}
}


/* This function makes another request to the API when the "SEE MORE" button is clicked
and sends data to the addVideoListElement function. The addVideoListElement then appends
5 new video buttons to the current list. This is exactly the same as the first function except
only 5 videos are pulled and the startIndex is different */
function loadMoreVideos()
{
	
	var numberOfVideos = document.getElementById("ignVideoList").childElementCount;
	
	
	$.ajax({
			url: 'http://ign-apis.herokuapp.com/videos?startIndex=' + numberOfVideos + '&count=5',
			dataType: 'jsonp',
			type: 'get',
			success: function(initialVideoList)
			{
				console.log(initialVideoList.data[0]);
				for (var i = 0; i < initialVideoList.data.length; i++)
				{
					console.log(initialVideoList.data[i].metadata.name + " " + i);
					addVideoListElement(initialVideoList.data[i].metadata.name, 
					initialVideoList.data[i].thumbnails[2].url, initialVideoList.data[i].metadata.url,
					initialVideoList.data[i].metadata.duration, numberOfVideos + i);
				}				
			}
		});
}
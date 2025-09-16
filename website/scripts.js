var API_BASE_URL = "https://e207zdmodf.execute-api.us-east-1.amazonaws.com/prod";

document.getElementById("sayButton").onclick = function () {
	var inputData = {
		"voice": $('#voiceSelected option:selected').val(),
		"text": $('#postText').val()
	};

	$.ajax({
		url: API_BASE_URL + "/new_post",
		type: 'POST',
		data: JSON.stringify(inputData),
		contentType: 'application/json; charset=utf-8',
		success: function (response) {
			document.getElementById("postIDreturned").textContent = "Post ID: " + response;
			$('#postId').val(response); // Carga automática del ID para usarlo en el search
		},
		error: function (xhr) {
			alert("Error: " + xhr.responseText);
		}
	});
};

document.getElementById("searchButton").onclick = function () {
	var postId = $('#postId').val().trim();

	if (postId === "") {
		alert("Please enter a post ID.");
		return;
	}

	$.ajax({
		url: API_BASE_URL + "/get-post?postId=" + postId,
		type: 'GET',
		success: function (response) {
			$('#posts tr').slice(1).remove();

			if (typeof response === "string") {
				response = JSON.parse(response);
			}

			console.log("Respuesta:", response);

			jQuery.each(response, function (i, data) {
				let bucket = "mp3-bucket-yourname-2025"; 
				let region = "us-east-1";
				let url = `https://${bucket}.s3.${region}.amazonaws.com/${data['id']}.mp3`;

				if (data['url']) {
					player = "<audio controls><source src='" + data['url'] + "' type='audio/mpeg'></audio>";
					download = "<br><a href='" + data['url'] + "' download style='text-decoration:none;color:orange;'>⬇️ Download MP3</a>";
				}

				$("#posts").append("<tr> \
					<td>" + data['id'] + "</td> \
					<td>" + data['voice'] + "</td> \
					<td>" + data['text'] + "</td> \
					<td>" + data['status'] + "</td> \
					<td>" + player + download + "</td> \
				</tr>");
			});
		},
		error: function (xhr) {
			alert("Error: " + xhr.responseText);
		}
	});
};

document.getElementById("postText").onkeyup = function () {
	var length = $('#postText').val().length;
	document.getElementById("charCounter").textContent = "Characters: " + length;
};

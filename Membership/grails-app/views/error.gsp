<!DOCTYPE html>
<html>
	<head>
		<title><g:if env="development">Error Page</g:if><g:else>Error</g:else></title>
		<meta name="layout" content="main">
		<g:if env="development"><asset:stylesheet src="errors.css"/></g:if>
	</head>
	<body>
		<g:if env="development">
			<h2>Houston, we have a problem!</h2>
			<g:renderException exception="${exception}" />
			<div class="message">
            <strong>Error ${request.'javax.servlet.error.status_code'}:</strong>
            ${request.'javax.servlet.error.message'.encodeAsHTML()}<br/>
            <strong>Servlet:</strong> ${request.'javax.servlet.error.servlet_name'}<br/>
            <strong>URI:</strong> ${request.'javax.servlet.error.request_uri'}<br/>
            <g:if test="${exception}">
                <strong>Exception Message:</strong> ${exception.message?.encodeAsHTML()} <br/>
                <strong>Caused by:</strong> ${exception.cause?.message?.encodeAsHTML()} <br/>
                <strong>Class:</strong> ${exception.className} <br/>
                <strong>At Line:</strong> [${exception.lineNumber}] <br/>
                <strong>Code Snippet:</strong><br/>

                <div class="snippet">
                    <g:each var="cs" in="${exception.codeSnippet}">
                        ${cs?.encodeAsHTML()}<br/>
                    </g:each>
                </div>
            </g:if>
        </div>
        <g:if test="${exception}">
            <h2>Stack Trace</h2>

            <div class="stack">
                <pre><g:each in="${exception.stackTraceLines}">${it.encodeAsHTML()}<br/></g:each></pre>
            </div>
        </g:if>
		</g:if>
		<g:else>
			<ul class="errors">
				<li>An error has occurred</li>
			</ul>
		</g:else>
	</body>
</html>

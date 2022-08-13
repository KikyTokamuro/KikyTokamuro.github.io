document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("pre code").forEach(block => {
        hljs.highlightBlock(block);
    });
});
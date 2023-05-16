function closeAlertAndRedirect(path) {
    // Close the alert
    let alertElement = document.querySelector('.alert');
    if (alertElement) {
        alertElement.style.display = 'none';
    }

    // Redirect to the specified path
    window.location.href = path;
}
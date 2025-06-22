// Function to dynamically show/hide forms based on radio button selection
function toggleTriggerForm() {
    // Hide all forms first
    document.querySelectorAll('.trigger-form').forEach(form => {
        form.style.display = 'none';
    });

    // Find the selected radio button and show its corresponding form
    const selectedRadio = document.querySelector('input[name="trigger_option"]:checked');
    if (selectedRadio) {
        const formId = selectedRadio.value + '-form';
        const formElement = document.getElementById(formId);
        if (formElement) {
            formElement.style.display = 'block';
        }
    }
}

// Attach event listeners to radio buttons on the Triggers page
document.addEventListener('DOMContentLoaded', () => {
    const triggerRadios = document.querySelectorAll('input[name="trigger_option"]');
    triggerRadios.forEach(radio => {
        radio.addEventListener('change', toggleTriggerForm);
    });

    // Initial call to set the correct form visibility on page load
    if (triggerRadios.length > 0) {
        toggleTriggerForm();
    }
});
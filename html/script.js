$(function() {
    const announcementContainer = $("#announcement-container");
    const announcementText = $("#announcement-text");
    const announcementTitle = $("#announcement-title");
    const iconElement = $(".announcement-icon-area i");

    let currentDisplayDuration = 10000; // Default value, overridden by NUI message
    let audioPlayer = null;

    // Function to play sounds
    function playSound(soundPath, volume) {
        if (soundPath) {
            if (audioPlayer) {
                audioPlayer.pause();
                audioPlayer.removeAttribute('src');
                audioPlayer.load();
                audioPlayer = null;
            }
            audioPlayer = new Audio(soundPath);
            let parsedVolume = parseFloat(volume);
            if (isNaN(parsedVolume) || parsedVolume < 0 || parsedVolume > 1) {
                // Fallback to a default value or from config if available
                // Here we take 0.5 as a safe fallback if everything else fails
                parsedVolume = 0.5; 
            }
            audioPlayer.volume = parsedVolume;

            const playPromise = audioPlayer.play();

            if (playPromise !== undefined) {
                playPromise.then(_ => {
                    // Audio started successfully
                    // console.log(`[zhora_announce] Sound started: ${soundPath}`);
                }).catch(error => {
                    // Prevents uncaught promise rejections from flooding the console,
                    // when user hasn't interacted with the page yet.
                    // console.error(`[zhora_announce] Error playing sound (${soundPath}):`, error);
                });
            }
        }
    }

    // Definition of styles for different announcement types
    const typeStyles = {
        "info": { iconClass: "fa-solid fa-info-circle", color: "#5ac8fa" },
        "warning": { iconClass: "fa-solid fa-triangle-exclamation", color: "#ff9f0a" },
        "wichtig": { iconClass: "fa-solid fa-circle-exclamation", color: "#ff3b30" }, // 'wichtig' instead of 'important'
        "server": { iconClass: "fa-solid fa-server", color: "#8e8e93" },
        "announcement": { iconClass: "fa-solid fa-bullhorn", color: "#ff9500" }, // If you use this type
        "information": { iconClass: "fa-solid fa-book-open-reader", color: "#5ac8fa" }, // Alternative to 'info'
        "datasaved": { iconClass: "fa-solid fa-database", color: "#34c759" }, // Example for data saving
        "error": { iconClass: "fa-solid fa-ban", color: "#ff3b30" },
        "success": { iconClass: "fa-solid fa-check-circle", color: "#34c759" },
        "bank": { iconClass: "fa-solid fa-building-columns", color: "#007aff" }, // Example for bank
        "characterstatus": { iconClass: "fa-solid fa-user-injured", color: "#ff3b30" }, // Example for character status
        "default": { iconClass: "fa-solid fa-bell", color: "#8e8e93" } // Default fallback
        // Add more types here or adjust existing ones,
        // according to your zhora_announce/config.lua and client.lua
    };

    // Event listener for messages from client.lua
    window.addEventListener('message', function(event) {
        const data = event.data;

        switch (data.type) {
            case "showAnnouncement":
                // Important: Reset classes before making visible
                announcementContainer.removeClass("hidden exiting");
                // Optional: If you were using display:none for .hidden, set back to 'flex' here
                // announcementContainer.css('display', 'flex'); // Ensures the container is visible

                announcementText.html(data.text || ""); // .html() to allow formatting; fallback to empty string
                announcementTitle.text(data.sender || "Announcement"); // Using sender as title now
                currentDisplayDuration = data.duration || 10000; // Duration from message or default

                const currentType = data.announcementType ? data.announcementType.toLowerCase() : "info";
                const style = typeStyles[currentType] || typeStyles["default"];

                // Remove old type classes before adding the new one
                // This is useful if you had CSS rules per type (e.g. .announcement-container.wichtig)
                Object.keys(typeStyles).forEach(typeName => {
                    announcementContainer.removeClass(typeName);
                });
                if (typeStyles[currentType]) { // Only add the type class if it's defined
                    announcementContainer.addClass(currentType);
                }

                iconElement.attr('class', style.iconClass).css('color', style.color);

                // Force reflow so the CSS transition plays correctly
                announcementContainer[0].offsetHeight;
                announcementContainer.addClass("visible"); // Starts fade-in and pulse animation

                if (data.soundFile) {
                    playSound(data.soundFile, data.volume);
                }
                break;

            case "hideAnnouncement":
                announcementContainer.removeClass("visible").addClass("exiting"); // Starts fade-out animation

                // Wait until fade-out animation is complete (0.7s = 700ms)
                setTimeout(() => {
                    // Only finally hide if it wasn't shown again in the meantime
                    if (announcementContainer.hasClass("exiting")) {
                        announcementContainer.removeClass("exiting").addClass("hidden");
                        // Optional: If display:none for .hidden was used
                        // announcementContainer.css('display', 'none');
                    }
                }, 700); // This time must match the transition-duration of the .exiting class in CSS
                break;
            
            // Optional: If you have a queue display
            case "queuedAnnouncement":
                // Here you could display the number of waiting messages if desired
                // console.log("Announcements in queue: " + data.count);
                break;

            default:
                // Unknown message type
                // console.log("[zhora_announce] Unknown NUI message type: " + data.type);
                break;
        }
    });
});
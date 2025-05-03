// @File(encoding="UTF-8")
// Scratch Healing Rate Calculator for ImageJ/FIJI
macro "Calculate Scratch Healing Rate" {
    requires("1.53c");  // Ensure ImageJ version compatibility
    
    // Initialize variables
    scale = getNumber("Enter scale (um/pixel), if not calibrated enter 1:", 1);
    if (scale <= 0) {
        exit("Error: Scale must be greater than 0");
    }
    unit = "um";
    continueAnalysis = true;
    groupCount = 0;
    healingRates = newArray(0);  // Array to store healing rates
    groupLabels = newArray(0);   // Array to store group labels
    
    while (continueAnalysis) {
        groupCount++;
        print("\n=== Group " + groupCount + " Analysis ===");
        print("=== Scratch Healing Rate Analysis ===");
        
        // Step 1: Open 0h image
        open();
        if (nImages == 0) {
            exit("Error: Failed to open 0h image");
        }
        img0 = getTitle();
        // Switch to line tool
        setTool("line");
        waitForUser("Step 1", "On image '" + img0 + "':\n"
            + "1. Use line tool to measure scratch width\n"
            + "2. Ensure line is perpendicular to scratch edges\n"
            + "3. Then click 'OK'");
        
        // Check if line is drawn
        if (selectionType() != 5) {  // 5 represents line selection
            exit("Error: Please draw a line first");
        }
        run("Measure");
        width0 = getResult("Length", nResults-1) * scale;
        close();  // Close 0h image
        
        // Step 2: Open 24h image
        open();
        if (nImages < 1) {  // Changed from 2 to 1 since we closed the first image
            exit("Error: Failed to open 24h image");
        }
        img24 = getTitle();
        // Switch to line tool
        setTool("line");
        waitForUser("Step 2", "On image '" + img24 + "':\n"
            + "1. Use line tool to measure scratch width\n"
            + "2. Ensure line is perpendicular to scratch edges\n"
            + "3. Then click 'OK'");
        
        // Check if line is drawn
        if (selectionType() != 5) {
            exit("Error: Please draw a line first");
        }
        run("Measure");
        width24 = getResult("Length", nResults-1) * scale;
        close();  // Close 24h image
        
        // Validate measurements
        if (width24 > width0) {
            showMessageWithCancel("Warning", "24h scratch width is larger than 0h width, this might be incorrect.\nDo you want to continue?");
        }
        
        // Calculate healing rate
        healingRate = (width0 - width24) / width0 * 100;  // Convert to percentage
        
        // Store healing rate for summary
        healingRates = Array.concat(healingRates, healingRate);
        groupLabels = Array.concat(groupLabels, "Group " + groupCount);
        
        // Output to Log
        print("Scale: " + scale + " " + unit + "/pixel");
        print("0h Image: " + img0);
        print("  Width: " + d2s(width0,1) + " " + unit);
        print("24h Image: " + img24);
        print("  Width: " + d2s(width24,1) + " " + unit);
        print("Healing Rate: " + d2s(healingRate,2) + "%");
        
        // Add results to the table
        row = nResults;
        setResult("Group", row, groupCount);
        setResult("Image", row, img0);
        setResult("Width ("+unit+")", row, width0);
        row = row + 1;
        setResult("Group", row, groupCount);
        setResult("Image", row, img24);
        setResult("Width ("+unit+")", row, width24);
        row = row + 1;
        setResult("Group", row, groupCount);
        setResult("Image", row, "Healing Rate");
        setResult("Width ("+unit+")", row, healingRate);
        updateResults();
        
        // Ask user whether to continue or end
        Dialog.create("Analysis Complete");
        Dialog.addMessage("Results have been saved to Results table.\nDetailed information can be found in Log window.");
        Dialog.addChoice("What would you like to do?", newArray("Analyze Next Group", "End Analysis"));
        Dialog.show();
        choice = Dialog.getChoice();
        
        if (choice == "End Analysis") {
            continueAnalysis = false;
            
            // Calculate statistics
            Array.getStatistics(healingRates, min, max, mean, stdDev);
            
            // Print summary table
            print("\n=== Analysis Summary ===");
            print("Total groups analyzed: " + groupCount);
            print("\nHealing Rates Summary:");
            print("Group           Healing Rate");
            print("-----           -----------");
            for (i = 0; i < healingRates.length; i++) {
                groupText = groupLabels[i];
                while (lengthOf(groupText) < 15) groupText += " ";
                print(groupText + d2s(healingRates[i],2) + "%");
            }
            
            print("\nStatistical Analysis:");
            print("Mean Healing Rate: " + d2s(mean,2) + "%");
            print("Standard Deviation: " + d2s(stdDev,2) + "%");
            print("Minimum: " + d2s(min,2) + "%");
            print("Maximum: " + d2s(max,2) + "%");
            
            selectWindow("Log");
            saveAs("Text");  // Prompt to save the Log
            selectWindow("Results");
            saveAs("Results");  // Prompt to save the Results table
        }
    }
}
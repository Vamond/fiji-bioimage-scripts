// @File(encoding="UTF-8")
// Scratch Area Healing Rate Calculator for ImageJ/FIJI
macro "Calculate Scratch Area Healing Rate" {
    requires("1.53c");
    
    // Initialize variables
    continueAnalysis = true;
    groupCount = 0;
    healingRates = newArray(0);  // Array to store healing rates
    groupLabels = newArray(0);   // Array to store group labels
    
    while (continueAnalysis) {
        groupCount++;
        print("\n=== Group " + groupCount + " Analysis ===");
        print("=== Scratch Area Healing Rate Analysis ===");
        
        // Step 1: Process and analyze 0h image
        open();
        if (nImages == 0) {
            exit("Error: Failed to open 0h image");
        }
        img0 = getTitle();
        
        // Image processing steps
        print("\\Clear"); // Clear log window
        print("=== Processing " + img0 + " ===");
        
        print("1. Converting to 8-bit");
        run("8-bit");
        
        print("2. Applying Smooth filter");
        run("Smooth");
        
        print("3. Finding edges");
        run("Find Edges");
        
        print("4. Enhancing contrast");
        run("Enhance Contrast...", "saturated=0.35 normalize");
        
        print("5. Applying Gaussian Blur");
        run("Gaussian Blur...", "sigma=6");
        
        // Threshold adjustment
        print("6. Setting auto threshold");
        setAutoThreshold("Default dark");
        setThreshold(0, 10);
        
        run("Threshold...");
        waitForUser("Step 1", "Adjust threshold to highlight scratch area:\n"
            + "1. Move sliders to get best contrast of scratch area\n"
            + "2. Click Apply\n"
            + "3. Click OK here when done");
            
        // Selection and measurement
        print("7. Ready for wand tool selection");
        setTool("wand");
        waitForUser("Step 2", "Now:\n"
            + "1. Click inside the scratch area with the wand tool\n"
            + "2. Hold Shift and click to add more areas if needed\n"
            + "3. Then click OK");
            
        if (selectionType() == -1) {
            exit("Error: Please select the scratch area first");
        }
        
        // Process selection
        print("8. Processing selection");
        print("  - Filling selection");
        run("Fill");
        
        print("  - Clearing outside");
        run("Clear Outside");
        
        print("9. Measuring area");
        run("Measure");
        area0 = getResult("Area", nResults-1);
        print("   Measured area: " + d2s(area0,1) + " pixels²");
        
        run("Select None");
        
        // Save final processed image
        saveAs("Tiff", File.directory + File.separator + "processed_" + img0);
        print("Final processed image saved");
        
        close();  // Close 0h image
        
        // Step 2: Process and analyze 24h image
        open();
        if (nImages < 1) {
            exit("Error: Failed to open 24h image");
        }
        img24 = getTitle();
        
        // Image processing steps
        print("\n=== Processing " + img24 + " ===");
        
        print("1. Converting to 8-bit");
        run("8-bit");
        
        print("2. Applying Smooth filter");
        run("Smooth");
        
        print("3. Finding edges");
        run("Find Edges");
        
        print("4. Enhancing contrast");
        run("Enhance Contrast...", "saturated=0.35 normalize");
        
        print("5. Applying Gaussian Blur");
        run("Gaussian Blur...", "sigma=6");
        
        // Threshold adjustment
        print("6. Setting auto threshold");
        setAutoThreshold("Default dark");
        setThreshold(0, 10);
        
        run("Threshold...");
        waitForUser("Step 1", "Adjust threshold to highlight scratch area:\n"
            + "1. Move sliders to get best contrast of scratch area\n"
            + "2. Click Apply\n"
            + "3. Click OK here when done");
            
        // Selection and measurement
        print("7. Ready for wand tool selection");
        setTool("wand");
        waitForUser("Step 2", "Now:\n"
            + "1. Click inside the scratch area with the wand tool\n"
            + "2. Hold Shift and click to add more areas if needed\n"
            + "3. Then click OK");
            
        if (selectionType() == -1) {
            exit("Error: Please select the scratch area first");
        }
        
        // Process selection
        print("8. Processing selection");
        print("  - Filling selection");
        run("Fill");
        
        print("  - Clearing outside");
        run("Clear Outside");
        
        print("9. Measuring area");
        run("Measure");
        area24 = getResult("Area", nResults-1);
        print("   Measured area: " + d2s(area24,1) + " pixels²");
        
        run("Select None");
        
        // Save final processed image
        saveAs("Tiff", File.directory + File.separator + "processed_" + img24);
        print("Final processed image saved");
        
        close();  // Close 24h image
        
        if (area24 > area0) {
            showMessageWithCancel("Warning", "24h scratch area is larger than 0h area, this might be incorrect.\nDo you want to continue?");
        }
        
        healingRate = (area0 - area24) / area0 * 100;  // Convert to percentage
        
        // Store healing rate for summary
        healingRates = Array.concat(healingRates, healingRate);
        groupLabels = Array.concat(groupLabels, "Group " + groupCount);
        
        print("0h Image: " + img0);
        print("  Area: " + d2s(area0,1) + " pixels²");
        print("24h Image: " + img24);
        print("  Area: " + d2s(area24,1) + " pixels²");
        print("Healing Rate: " + d2s(healingRate,2) + "%");
        
        // Add results to the table
        row = nResults;
        setResult("Group", row, groupCount);
        setResult("Image", row, img0);
        setResult("Area (pixels²)", row, area0);
        row = row + 1;
        setResult("Group", row, groupCount);
        setResult("Image", row, img24);
        setResult("Area (pixels²)", row, area24);
        row = row + 1;
        setResult("Group", row, groupCount);
        setResult("Image", row, "Healing Rate");
        setResult("Area (pixels²)", row, healingRate);
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
            
            // Save all data
            if (roiManager("count") > 0) {
                roiManager("Save", File.directory + File.separator + "ROI_Set.zip");
            }
            
            selectWindow("Log");
            saveAs("Text");  // Prompt to save the Log
            selectWindow("Results");
            saveAs("Results");  // Prompt to save the Results table
            
            // Clean up
            roiManager("Delete");  // Clear ROI Manager
        }
    }
} 
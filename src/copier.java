import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

public class copier {
    public static void main(String[] args) {
        // String pathname =
        // "C:\\Users\\micha\\AppData\\Local\\.ftba\\instances\\5899d8fc-0033-442b-8f38-a507149f6083\\saves\\Turtleworld\\computercraft\\computer\\19";
        String bossPath = "I:\\Games\\Minecraft\\Instances\\167b0fe2-0022-4b7b-ad26-ef6e16e05a8e\\saves\\Turtles\\computercraft\\computer\\0";
        String diskPath = "I:\\Games\\Minecraft\\Instances\\167b0fe2-0022-4b7b-ad26-ef6e16e05a8e\\saves\\Turtles\\computercraft\\disk\\0";
        String[][] filesToKeepComputer = { { "bossState.michi", null }, { "pos.txt", null },
                { "computerstartup.lua", "startup" } };
        String[][] filesToKeepDisk = { { "multiTurtleStartup1.lua", "startup" },
                { "multiturtleStartup2", "turtleStartup" } };
        removeOldFiles(bossPath, filesToKeepComputer);
        removeOldFiles(diskPath, filesToKeepDisk);
        copyNewFiles(bossPath, filesToKeepComputer);
        copyNewFiles(diskPath, filesToKeepDisk);
    }

    public static void removeOldFiles(String path, String[][] filesToKeep) {
        File targetDir = new File(path);
        if (targetDir.exists()) {
            for (File file : targetDir.listFiles()) {
                boolean skip = false;
                for (String[] string : filesToKeep) {
                    if (file.getName().equalsIgnoreCase(string[0])) {
                        skip = true;
                    }
                }
                if (skip)
                    continue;
                System.out.println("Removing " + file.getPath());
                file.delete();
            }
        }
    }

    public static void copyNewFiles(String path, String[][] filesToKeep) {
        File targetDir = new File(path);
        if (!targetDir.exists()) {
            targetDir.mkdirs();
        }

        File sourceDir = new File("TurtlePrograms");
        for (File file : sourceDir.listFiles()) {
            boolean skip = false;
            for (String[] string : filesToKeep) {
                if (string[1] == null && file.getName().equalsIgnoreCase(string[0])) {
                    skip = true;
                }
            }
            if (skip)
                continue;
            try {
                if (file.isDirectory()) {
                    for (File file2 : file.listFiles()) {
                        skip = false;
                        for (String[] string : filesToKeep) {
                            if (string[1] != null && file2.getName().equalsIgnoreCase(string[0])) {
                                Files.copy(file2.toPath(), Path.of(path + "\\" + string[1]),
                                        StandardCopyOption.REPLACE_EXISTING);
                                skip = true;
                            }
                        }
                        if (!skip)
                            Files.copy(file2.toPath(), Path.of(path + "\\" + file2.getName()),
                                    StandardCopyOption.REPLACE_EXISTING);
                    }
                } else {
                    skip = false;
                    for (String[] string : filesToKeep) {
                        if (string[1] != null && file.getName().equalsIgnoreCase(string[0])) {
                            Files.copy(file.toPath(), Path.of(path + "\\" + string[1]),
                                    StandardCopyOption.REPLACE_EXISTING);
                            skip = true;
                        }
                    }
                    if (!skip)
                        Files.copy(file.toPath(), Path.of(path + "\\" + file.getName()),
                                StandardCopyOption.REPLACE_EXISTING);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
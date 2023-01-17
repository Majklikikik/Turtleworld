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
        String diskPath = "I:\\Games\\Minecraft\\Instances\\167b0fe2-0022-4b7b-ad26-ef6e16e05a8e\\saves\\Turtles\\computercraft\\computer\\1";
        String[][] filesToKeepComputer = {{"bossState.michi", null}, {"pos.txt", null}, {"computerstartup.lua","startup"} };
        String[][] filesToKeepDisk = {{"multiTurtleStartup1.lua","startup"}, {"multiturtleStartup2","turtleStartup"} };
        removeOldFiles(bossPath, diskPath, filesToKeepComputer, filesToKeepDisk);
        copyNewFiles(bossPath, diskPath, filesToKeepComputer, filesToKeepDisk);
    }

    public static void removeOldFiles(String bp, String dp, String[][] ftkC, String[][] ftkD) {
        File tf = new File(bp);
        if (tf.exists()) {
            for (File f : tf.listFiles()) {
                boolean skip = false;
                for (String[] string : ftkC) {
                    if (string[1]!=null && f.getName().equalsIgnoreCase(string[0])) {
                        skip = true;
                    }
                }
                if (skip)
                    continue;
                // String[] nameparts = f.getName().split("[.]");
                // String endung = nameparts[nameparts.length - 1];
                System.out.println("Removing " + f.getPath());
                f.delete();
            }
        }

        tf = new File(dp);
        if (tf.exists()) {
            for (File f : tf.listFiles()) {
                boolean skip = false;
                for (String[] string : ftkD) {
                    if (string[1]!=null && f.getName().equalsIgnoreCase(string[0])) {
                        skip = true;
                    }
                }
                if (skip)
                    continue;
                // String[] nameparts = f.getName().split("[.]");
                // String endung = nameparts[nameparts.length - 1];
                System.out.println("Removing " + f.getPath());
                f.delete();
            }
        }

    }

    public static void copyNewFiles(String bp, String dp, String[][] ftkC, String[][] ftkD) {
        File tf = new File(bp);
        if (!tf.exists()) {
            tf.mkdirs();
        }

        File folder = new File("TurtlePrograms");
        for (File f : folder.listFiles()) {
            boolean skip = false;
            for (String[] string : ftkC) {
                if (string[1]==null && f.getName().equalsIgnoreCase(string[0])) {
                    skip = true;
                }
            }
            if (skip)
                continue;
            try {
                if (f.isDirectory()) {
                    for (File g : f.listFiles()) {
                        skip = false;
                        for (String[] string : ftkC) {
                            if (string[1]!=null && f.getName().equalsIgnoreCase(string[0])) {
                                skip = true;
                                Files.copy(g.toPath(), Path.of(bp + "\\" + string[1]),
                                        StandardCopyOption.REPLACE_EXISTING);
                            }
                        }
                        if (skip) continue;
                        Files.copy(g.toPath(), Path.of(bp + "\\" + g.getName()),
                                StandardCopyOption.REPLACE_EXISTING);
                    }
                } else {
                    for (String[] string : ftkC) {
                        if (string[1]!=null && f.getName().equalsIgnoreCase(string[0])) {
                            skip = true;
                            Files.copy(f.toPath(), Path.of(bp + "\\" + string[1]),
                                    StandardCopyOption.REPLACE_EXISTING);
                        }
                    }
                    if (skip) continue;
                    Files.copy(f.toPath(), Path.of(bp + "\\" + f.getName()),
                            StandardCopyOption.REPLACE_EXISTING);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


        tf = new File(dp);
        if (!tf.exists()) {
            tf.mkdirs();
        }
        for (File f : folder.listFiles()) {
            boolean skip = false;
            for (String[] string : ftkD) {
                if (string[1]==null && f.getName().equalsIgnoreCase(string[0])) {
                    skip = true;
                }
            }
            if (skip)
                continue;
            try {
                if (f.isDirectory()) {
                    for (File g : f.listFiles()) {
                        skip = false;
                        for (String[] string : ftkD) {
                            if (string[1]!=null && f.getName().equalsIgnoreCase(string[0])) {
                                skip = true;
                                Files.copy(g.toPath(), Path.of(dp + "\\" + string[1]),
                                        StandardCopyOption.REPLACE_EXISTING);
                            }
                        }
                        if (skip) continue;
                        Files.copy(g.toPath(), Path.of(dp + "\\" + g.getName()),
                                StandardCopyOption.REPLACE_EXISTING);
                    }
                } else {
                    for (String[] string : ftkD) {
                        if (string[1]!=null && f.getName().equalsIgnoreCase(string[0])) {
                            skip = true;
                            Files.copy(f.toPath(), Path.of(dp + "\\" + string[1]),
                                    StandardCopyOption.REPLACE_EXISTING);
                        }
                    }
                    if (skip) continue;
                    Files.copy(f.toPath(), Path.of(dp + "\\" + f.getName()),
                            StandardCopyOption.REPLACE_EXISTING);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
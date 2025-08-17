import os
import glob

def rename_images_to_weeks():
    """
    Renames all images in the current directory to week1, week2, ..., week42
    Assumes you have exactly 42 image files.
    """
    current_dir = os.getcwd()
    extensions = ['*.png', '*.jpg', '*.jpeg', '*.bmp', '*.gif', '*.tiff', '*.webp']
    
    image_files = []
    for ext in extensions:
        image_files.extend(glob.glob(os.path.join(current_dir, ext)))
    
    image_files.sort()  # Ensure consistent order

    if len(image_files) < 38:
        print(f"Error: Found only {len(image_files)} image files. Need at least 42.")
        return

    for i in range(38):
        old_path = image_files[i]
        _, ext = os.path.splitext(old_path)
        new_name = f"week{i+1}{ext}"
        new_path = os.path.join(current_dir, new_name)
        
        try:
            os.rename(old_path, new_path)
            print(f"Renamed: {os.path.basename(old_path)} → {new_name}")
        except Exception as e:
            print(f"Error renaming {old_path}: {e}")
            return

    print("\n✅ Successfully renamed 42 images to week1 → week42.")

if __name__ == "__main__":
    rename_images_to_weeks()

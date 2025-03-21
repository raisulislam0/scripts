import asyncio
import os
import xml.etree.ElementTree as ET
from crawl4ai import AsyncWebCrawler

async def get_urls_from_local_sitemap(sitemap_path):
    # Parse the XML file from local path
    try:
        tree = ET.parse(sitemap_path)
        root = tree.getroot()
        
        # Find all URL elements (handling namespaces in sitemaps)
        namespace = {'sm': 'http://www.sitemaps.org/schemas/sitemap/0.9'}
        urls = [loc.text for loc in root.findall('.//sm:loc', namespace)]
        
        return urls
    except Exception as e:
        print(f"Error parsing sitemap: {str(e)}")
        return []

async def crawl_and_save_url(crawler, url, output_dir):
    try:
        result = await crawler.arun(url=url)
        
        # Create a filename from the URL
        filename = url.replace('://', '_').replace('/', '_').replace('?', '_').replace('&', '_')
        if len(filename) > 100:  # Avoid overly long filenames
            filename = filename[:100]
        filename = f"{filename}.md"
        
        # Save to file
        filepath = os.path.join(output_dir, filename)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(result.markdown)
        
        print(f"Saved: {url} -> {filepath}")
    except Exception as e:
        print(f"Error crawling {url}: {str(e)}")

async def main():
    # Define the sitemap file path and output directory
    sitemap_path = r"D:\sitemap\sitemap.xml"  # Use raw string to handle backslashes
    output_dir = "crawled_pages"
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Get URLs from sitemap
    print(f"Reading URLs from sitemap: {sitemap_path}")
    urls = await get_urls_from_local_sitemap(sitemap_path)
    print(f"Found {len(urls)} URLs in sitemap")
    
    # Crawl each URL and save results
    async with AsyncWebCrawler() as crawler:
        tasks = []
        for url in urls:
            task = crawl_and_save_url(crawler, url, output_dir)
            tasks.append(task)
        
        # Run crawling tasks with concurrency control
        # Process in batches to avoid overwhelming the server
        batch_size = 5  # Adjust based on your needs
        for i in range(0, len(tasks), batch_size):
            batch = tasks[i:i+batch_size]
            await asyncio.gather(*batch)
    
    print(f"Crawling complete. Results saved to {output_dir}/")

if __name__ == "__main__":
    asyncio.run(main())
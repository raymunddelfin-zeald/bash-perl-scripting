for site in `zeald_site_manager list cluster --format=catalog_name`; do 
    echo $site; 
    if [ -d "$site/logic/Integration" ]; then 
        echo "Integrations: " $(ls -l $site/logic/Integration | grep -v ^d | wc -l);  
    fi 
done
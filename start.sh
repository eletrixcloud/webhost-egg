#!/bin/ash
cat << 'EOF'
  ______   _____________  _____  _________   ____  __  _____ 
  / __/ /  / __/_  __/ _ \/  _/ |/_/ ___/ /  / __ \/ / / / _ \
 / _// /__/ _/  / / / , _// /_>  </ /__/ /__/ /_/ / /_/ / // /
/___/____/___/ /_/ /_/|_/___/_/|_|\___/____/\____/\____/____/ 
                                                              
EOF

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

log_success() {
    echo -e "${GREEN}${BOLD}[OK]${RESET}${GREEN} $1${RESET}"
}
log_warning() {
    echo -e "${YELLOW}${BOLD}[!!]${RESET}${YELLOW} $1${RESET}"
}
log_error() {
    echo -e "${RED}${BOLD}[XX]${RESET}${RED} $1${RESET}"
}
log_info() {
    echo -e "${CYAN}${BOLD}[->]${RESET}${CYAN} $1${RESET}"
}

log_info "Documentation : https://r.elxcloud.fr/web1"

log_info "Nettoyage des fichiers temporaires"
if rm -rf /home/container/tmp/*; then
    log_success "Fichiers temporaires supprimés."
else
    log_error "Échec de la suppression des fichiers temporaires."
    exit 1
fi

log_info "Démarrage de PHP-FPM"
if /usr/sbin/php-fpm8 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize; then
    log_success "PHP-FPM démarré avec succès."
else
    log_error "Échec du démarrage de PHP-FPM."
    exit 1
fi

log_info "Démarrage de Nginx"
if /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/; then
    log_success "Service Web démarré avec succès !"
else
    log_error "Échec du démarrage de Nginx."
    exit 1
fi

tail -f /dev/null

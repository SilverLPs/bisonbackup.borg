VAR_SOURCE=""
VAR_DESTINATION=""
VAR_PASSPHRASE=""
VAR_REMOTEPATH=""

for arg in "$@"; do
  case $arg in
    SOURCE=*)
      VAR_SOURCE="$(realpath "${arg#*=}")"
      shift
      ;;
    DESTINATION=*)
      VAR_DESTINATION="${arg#*=}"
      shift
      ;;
    PASSPHRASE=*)
      VAR_PASSPHRASE="${arg#*=}"
      shift
      ;;
    REMOTEPATH=*)
      VAR_REMOTEPATH="${arg#*=}"
      shift
      ;;
  esac
done

echo "MODULE INFO:"
echo
echo "Module:      bisonbackup.borg.backup"
echo "Path:        $(pwd)"
echo "SOURCE:      $VAR_SOURCE"
echo "DESTINATION: $VAR_DESTINATION"
if [[ -n "$VAR_PASSPHRASE" ]]; then
  echo "PASSPHRASE:  MD5=$(echo -n $VAR_PASSPHRASE | md5sum | awk '{print $1}')"
else
  echo "PASSPHRASE:   "
fi
echo "REMOTEPATH:  $VAR_REMOTEPATH"
echo
export BORG_PASSPHRASE="$VAR_PASSPHRASE"
BACKUPTIME="$(date +\%Y\%m\%d)-$(date +\%H\%M\%S)"
if [[ -n "$VAR_REMOTEPATH" ]]; then
  borg create --stats --remote-path="$VAR_REMOTEPATH" "$VAR_DESTINATION"::"$BACKUPTIME" "$VAR_SOURCE" -v
else
  borg create --stats "$VAR_DESTINATION"::"$BACKUPTIME" "$VAR_SOURCE" -v
fi
echo
export BORG_PASSPHRASE="cleared"
unset BORG_PASSPHRASE

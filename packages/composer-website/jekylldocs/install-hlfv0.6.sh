(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��.Y �[o�0�yx�� �21�BJ�AI`�S��&�B���>;e����R�i����s|α���xa���sk�$�:z篺0�� k���^���B��N��� |�P�$Qlb j���=�{����"9�/�z�~!�:�� <䭈�}���5�f"�"{�0�`��c5sʧ���4a���!F�����0�q�2 Mи�ݎH/�̆�����!?>����FR5u94�c@~�lp#K�~���H�z�o��h�=�k1��7Ei��Q����mmjkm�	�Y�PQ%c.I�1�TI�]I�4ԏk=�S���\���~�;O"�q��9����m�VDn�A�2OfcC����I7�q��'�>I^�c�ybH�s`?WqZ�3z��zY���4\����UU�e��E�QZ܉����ޟn�COS�%�J����?���m�.�6�i�F�"��G@���� =d�H7�Pn���g*�?�����%h���[� ��ʖ���P��F��y:YlE��\�H���v2�����' �V��Ȋ�q3���㢨.D�q_vh�C|��!b?j.O6�,��TxwL�͆������3���h�4]-p��6��y�Z��[�$+��F�I�Y�8��?d�L�[��";�����^*��=��Z��8�U�^�J[��/��N�b����D�s����P�\b�Tp�����_�v��'Э������_��2��`0��`0��`0��7�	�W� (  
using UnityEngine;

public class CameraMovement : MonoBehaviour
{
    private Camera m_Camera;
    public Transform[] m_CameraTarget;
    void Start()
    {
        m_Camera = Camera.main;
        if (m_Camera == null) return;
        if (m_CameraTarget[0] == null) return;
        m_Camera.transform.position = m_CameraTarget[0].transform.position;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F1)) m_Camera.transform.position = m_CameraTarget[0].transform.position;
        if (Input.GetKeyDown(KeyCode.F2)) m_Camera.transform.position = m_CameraTarget[1].transform.position;
        if (Input.GetKeyDown(KeyCode.F3)) m_Camera.transform.position = m_CameraTarget[2].transform.position;
    }
}

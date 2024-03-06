using System.Runtime.InteropServices;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class MonitoringManager : MonoBehaviour
{
    [SerializeField]
    private TextMeshProUGUI resultTextMesh;

    [SerializeField]
    private Button startMonitoringButton;

    [SerializeField]
    private Button stopMonitoringButton;

    private bool _isMonitoring;

    public bool isMonitoring
    {
        get => _isMonitoring;
        set
        {
            // Here we set the state of the buttons based on the monitoring status
            startMonitoringButton.interactable = !isMonitoring; // If it's  monitoring, disable Start Button
            stopMonitoringButton.interactable = isMonitoring; // If it's not monitoring, disable Stop Button

            _isMonitoring = value;
        }
    }

#if UNITY_IOS && !UNITY_EDITOR
    // Import functions from the native iOS Plugin

    [DllImport("__Internal")]
    private static extern string StartMonitoring();

    [DllImport("__Internal")]
    private static extern string StopMonitoring();
#endif

    public void OnPressStartMonitoring()
    {
#if UNITY_IOS && !UNITY_EDITOR
        Debug.Log("Started Monitoring RAM Usage");
        StartMonitoring();
#endif
    }

    public void OnPressStopMonitoring()
    {
#if UNITY_IOS && !UNITY_EDITOR
        Debug.Log("Stopped Monitoring RAM Usage");
        string result = StopMonitoring();
        resultTextMesh.text = result;
#endif
    }
}
